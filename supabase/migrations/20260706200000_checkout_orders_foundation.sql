create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  restaurant_id text not null references public.restaurants (id),
  subtotal_in_cents integer not null,
  delivery_fee_in_cents integer not null,
  total_in_cents integer not null,
  payment_method text not null default 'cash_on_delivery',
  delivery_address text not null,
  status text not null default 'placed',
  created_at timestamptz not null default timezone('utc', now()),
  constraint orders_subtotal_in_cents_nonnegative check (
    subtotal_in_cents >= 0
  ),
  constraint orders_delivery_fee_in_cents_nonnegative check (
    delivery_fee_in_cents >= 0
  ),
  constraint orders_total_in_cents_nonnegative check (total_in_cents >= 0),
  constraint orders_total_consistency check (
    total_in_cents = subtotal_in_cents + delivery_fee_in_cents
  ),
  constraint orders_payment_method_supported check (
    payment_method = 'cash_on_delivery'
  ),
  constraint orders_status_supported check (status = 'placed'),
  constraint orders_delivery_address_not_blank check (
    btrim(delivery_address) <> ''
  )
);

create index if not exists orders_user_created_at_idx
  on public.orders (user_id, created_at desc);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  product_id text not null,
  product_name text not null,
  unit_price_in_cents integer not null,
  quantity integer not null,
  constraint order_items_product_id_not_blank check (btrim(product_id) <> ''),
  constraint order_items_product_name_not_blank check (
    btrim(product_name) <> ''
  ),
  constraint order_items_unit_price_in_cents_nonnegative check (
    unit_price_in_cents >= 0
  ),
  constraint order_items_quantity_positive check (quantity >= 1)
);

create index if not exists order_items_order_idx
  on public.order_items (order_id);

revoke all on public.orders from anon;
revoke all on public.order_items from anon;
revoke all on public.orders from authenticated;
revoke all on public.order_items from authenticated;
revoke all on public.orders from service_role;
revoke all on public.order_items from service_role;

grant usage on schema public to authenticated;
grant usage on schema public to service_role;

grant select, insert on public.orders to authenticated;
grant select, insert on public.order_items to authenticated;
grant select on public.orders to service_role;
grant select on public.order_items to service_role;

alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "Authenticated users can read own orders"
  on public.orders;
create policy "Authenticated users can read own orders"
  on public.orders
  for select
  to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "Authenticated users can create own orders"
  on public.orders;
create policy "Authenticated users can create own orders"
  on public.orders
  for insert
  to authenticated
  with check (user_id = (select auth.uid()));

drop policy if exists "Authenticated users can read own order items"
  on public.order_items;
create policy "Authenticated users can read own order items"
  on public.order_items
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.orders as parent_order
      where parent_order.id = order_items.order_id
        and parent_order.user_id = (select auth.uid())
    )
  );

drop policy if exists "Authenticated users can create own order items"
  on public.order_items;
create policy "Authenticated users can create own order items"
  on public.order_items
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.orders as parent_order
      where parent_order.id = order_items.order_id
        and parent_order.user_id = (select auth.uid())
    )
  );

create or replace function public.create_order(
  restaurant_id text,
  delivery_address text,
  delivery_fee_in_cents integer,
  items jsonb
) returns table (
  order_id uuid,
  order_total_in_cents integer,
  order_created_at timestamptz
)
language plpgsql
security invoker
set search_path = ''
as $$
declare
  computed_subtotal_in_cents integer;
  created_order public.orders%rowtype;
begin
  if create_order.items is null
    or jsonb_typeof(create_order.items) <> 'array'
    or jsonb_array_length(create_order.items) = 0 then
    raise exception 'create_order requires a non-empty items array'
      using errcode = '22023';
  end if;

  -- Subtotal and total are derived server-side from the submitted items so
  -- client-side math is never the source of truth for persisted amounts.
  select coalesce(
      sum(
        (item ->> 'unit_price_in_cents')::integer
          * (item ->> 'quantity')::integer
      ),
      0
    )
    into computed_subtotal_in_cents
  from jsonb_array_elements(create_order.items) as item;

  insert into public.orders (
    restaurant_id,
    subtotal_in_cents,
    delivery_fee_in_cents,
    total_in_cents,
    delivery_address
  )
  values (
    create_order.restaurant_id,
    computed_subtotal_in_cents,
    create_order.delivery_fee_in_cents,
    computed_subtotal_in_cents + create_order.delivery_fee_in_cents,
    create_order.delivery_address
  )
  returning * into created_order;

  insert into public.order_items (
    order_id,
    product_id,
    product_name,
    unit_price_in_cents,
    quantity
  )
  select
    created_order.id,
    item ->> 'product_id',
    item ->> 'product_name',
    (item ->> 'unit_price_in_cents')::integer,
    (item ->> 'quantity')::integer
  from jsonb_array_elements(create_order.items) as item;

  return query
  select created_order.id, created_order.total_in_cents,
    created_order.created_at;
end;
$$;

revoke all on function public.create_order(text, text, integer, jsonb)
  from public;
revoke all on function public.create_order(text, text, integer, jsonb)
  from anon;
grant execute on function public.create_order(text, text, integer, jsonb)
  to authenticated;
grant execute on function public.create_order(text, text, integer, jsonb)
  to service_role;
