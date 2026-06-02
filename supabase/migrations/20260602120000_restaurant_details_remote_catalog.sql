create table if not exists public.restaurant_menu_categories (
  restaurant_id text not null references public.restaurants (id) on delete cascade,
  id text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  constraint restaurant_menu_categories_pkey primary key (restaurant_id, id),
  constraint restaurant_menu_categories_id_lowercase check (id = lower(id)),
  constraint restaurant_menu_categories_id_not_blank check (btrim(id) <> ''),
  constraint restaurant_menu_categories_sort_order_nonnegative check (
    sort_order >= 0
  )
);

create index if not exists restaurant_menu_categories_restaurant_sort_order_idx
  on public.restaurant_menu_categories (restaurant_id, sort_order, id);

create table if not exists public.restaurant_menu_items (
  id text primary key,
  restaurant_id text not null references public.restaurants (id) on delete cascade,
  category_id text not null,
  name text not null,
  description text not null,
  image_asset_path text not null,
  price_in_cents integer not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  constraint restaurant_menu_items_category_fkey foreign key (
    restaurant_id,
    category_id
  ) references public.restaurant_menu_categories (restaurant_id, id)
    on delete cascade,
  constraint restaurant_menu_items_id_lowercase check (id = lower(id)),
  constraint restaurant_menu_items_id_not_blank check (btrim(id) <> ''),
  constraint restaurant_menu_items_category_id_lowercase check (
    category_id = lower(category_id)
  ),
  constraint restaurant_menu_items_category_id_not_blank check (
    btrim(category_id) <> ''
  ),
  constraint restaurant_menu_items_name_not_blank check (btrim(name) <> ''),
  constraint restaurant_menu_items_description_not_blank check (
    btrim(description) <> ''
  ),
  constraint restaurant_menu_items_image_asset_path_not_blank check (
    btrim(image_asset_path) <> ''
  ),
  constraint restaurant_menu_items_price_in_cents_nonnegative check (
    price_in_cents >= 0
  ),
  constraint restaurant_menu_items_sort_order_nonnegative check (
    sort_order >= 0
  )
);

create index if not exists restaurant_menu_items_restaurant_category_sort_order_idx
  on public.restaurant_menu_items (restaurant_id, category_id, sort_order, id);

revoke all on public.restaurant_menu_categories from anon;
revoke all on public.restaurant_menu_items from anon;
revoke all on public.restaurant_menu_categories from authenticated;
revoke all on public.restaurant_menu_items from authenticated;
revoke all on public.restaurant_menu_categories from service_role;
revoke all on public.restaurant_menu_items from service_role;

grant usage on schema public to authenticated;
grant usage on schema public to service_role;

grant select on public.restaurant_menu_categories to authenticated;
grant select on public.restaurant_menu_categories to service_role;
grant select on public.restaurant_menu_items to authenticated;
grant select on public.restaurant_menu_items to service_role;

alter table public.restaurant_menu_categories enable row level security;
alter table public.restaurant_menu_items enable row level security;

drop policy if exists "Authenticated users can read restaurant menu categories"
  on public.restaurant_menu_categories;
create policy "Authenticated users can read restaurant menu categories"
  on public.restaurant_menu_categories
  for select
  to authenticated
  using (true);

drop policy if exists "Authenticated users can read restaurant menu items"
  on public.restaurant_menu_items;
create policy "Authenticated users can read restaurant menu items"
  on public.restaurant_menu_items
  for select
  to authenticated
  using (true);

insert into public.restaurant_menu_categories (
  restaurant_id,
  id,
  sort_order
)
values
  ('burger_artisan_collective', 'popular', 0),
  ('burger_artisan_collective', 'burgers', 1),
  ('burger_artisan_collective', 'sides', 2),
  ('burger_artisan_collective', 'drinks', 3)
on conflict (restaurant_id, id) do update
set sort_order = excluded.sort_order;

insert into public.restaurant_menu_items (
  id,
  restaurant_id,
  category_id,
  name,
  description,
  image_asset_path,
  price_in_cents,
  sort_order
)
values
  (
    'signature_truffle',
    'burger_artisan_collective',
    'burgers',
    'The Signature Truffle',
    'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1850,
    0
  ),
  (
    'spicy_nashville_chicken',
    'burger_artisan_collective',
    'burgers',
    'Spicy Nashville Chicken',
    'Crispy chicken breast, cayenne glaze, slaw, and pickles.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1400,
    1
  ),
  (
    'sweet_potato_crisp',
    'burger_artisan_collective',
    'sides',
    'Sweet Potato Crisp',
    'Hand-cut sweet potato fries with maple-chipotle dipping sauce.',
    'assets/images/branding/logo-flowdelivery-light.png',
    650,
    0
  ),
  (
    'artisan_milkshake',
    'burger_artisan_collective',
    'drinks',
    'Artisan Milkshake',
    'Double-churned vanilla bean ice cream with Madagascar vanilla.',
    'assets/images/branding/logo-flowdelivery-light.png',
    750,
    0
  )
on conflict (id) do update
set
  restaurant_id = excluded.restaurant_id,
  category_id = excluded.category_id,
  name = excluded.name,
  description = excluded.description,
  image_asset_path = excluded.image_asset_path,
  price_in_cents = excluded.price_in_cents,
  sort_order = excluded.sort_order;
