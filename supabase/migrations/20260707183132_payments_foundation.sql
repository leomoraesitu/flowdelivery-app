alter table public.orders
  add constraint orders_id_user_id_unique unique (id, user_id);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique,
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  amount_in_cents integer not null,
  currency text not null default 'BRL',
  method text not null default 'cash_on_delivery',
  provider text not null default 'offline',
  status text not null default 'pending_on_delivery',
  provider_reference text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint payments_order_user_fk
    foreign key (order_id, user_id)
    references public.orders (id, user_id)
    on delete cascade,
  constraint payments_amount_in_cents_nonnegative check (
    amount_in_cents >= 0
  ),
  constraint payments_currency_supported check (currency = 'BRL'),
  constraint payments_method_supported check (
    method = 'cash_on_delivery'
  ),
  constraint payments_provider_supported check (provider = 'offline'),
  constraint payments_status_supported check (
    status = 'pending_on_delivery'
  ),
  constraint payments_provider_reference_not_blank check (
    provider_reference is null or btrim(provider_reference) <> ''
  )
);

create index if not exists payments_user_created_at_idx
  on public.payments (user_id, created_at desc);

revoke all on public.payments from anon;
revoke all on public.payments from authenticated;
revoke all on public.payments from service_role;

grant usage on schema public to authenticated;
grant usage on schema public to service_role;

grant select, insert on public.payments to authenticated;
grant select on public.payments to service_role;

alter table public.payments enable row level security;

drop policy if exists "Authenticated users can read own payments"
  on public.payments;
create policy "Authenticated users can read own payments"
  on public.payments
  for select
  to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "Authenticated users can create own order payments"
  on public.payments;
create policy "Authenticated users can create own order payments"
  on public.payments
  for insert
  to authenticated
  with check (
    user_id = (select auth.uid())
    and exists (
      select 1
      from public.orders as parent_order
      where parent_order.id = payments.order_id
        and parent_order.user_id = (select auth.uid())
    )
  );

drop function if exists public.create_order(
  text,
  text,
  integer,
  jsonb
);

create or replace function public.create_order(
  restaurant_id text,
  delivery_address text,
  delivery_fee_in_cents integer,
  items jsonb,
  order_payment_method text default 'cash_on_delivery'
) returns table (
  order_id uuid,
  order_total_in_cents integer,
  order_created_at timestamptz,
  payment_id uuid,
  payment_method text,
  payment_status text,
  payment_amount_in_cents integer
)
language plpgsql
security invoker
set search_path = ''
as $$
declare
  computed_subtotal_in_cents integer;
  created_order public.orders%rowtype;
  created_payment public.payments%rowtype;
begin
  if create_order.items is null
    or jsonb_typeof(create_order.items) <> 'array'
    or jsonb_array_length(create_order.items) = 0 then
    raise exception 'create_order requires a non-empty items array'
      using errcode = '22023';
  end if;

  if create_order.order_payment_method <> 'cash_on_delivery' then
    raise exception 'create_order received an unsupported payment method'
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
    payment_method,
    delivery_address
  )
  values (
    create_order.restaurant_id,
    computed_subtotal_in_cents,
    create_order.delivery_fee_in_cents,
    computed_subtotal_in_cents + create_order.delivery_fee_in_cents,
    create_order.order_payment_method,
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

  insert into public.payments (
    order_id,
    user_id,
    amount_in_cents,
    method
  )
  values (
    created_order.id,
    created_order.user_id,
    created_order.total_in_cents,
    create_order.order_payment_method
  )
  returning * into created_payment;

  return query
  select
    created_order.id,
    created_order.total_in_cents,
    created_order.created_at,
    created_payment.id,
    created_payment.method,
    created_payment.status,
    created_payment.amount_in_cents;
end;
$$;

revoke all on function public.create_order(
  text,
  text,
  integer,
  jsonb,
  text
) from public;
revoke all on function public.create_order(
  text,
  text,
  integer,
  jsonb,
  text
) from anon;
grant execute on function public.create_order(
  text,
  text,
  integer,
  jsonb,
  text
) to authenticated;
grant execute on function public.create_order(
  text,
  text,
  integer,
  jsonb,
  text
) to service_role;
