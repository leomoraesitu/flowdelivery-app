create table if not exists public.restaurant_categories (
  id text primary key,
  sort_order integer not null,
  created_at timestamptz not null default timezone('utc', now()),
  constraint restaurant_categories_id_lowercase check (id = lower(id)),
  constraint restaurant_categories_id_not_blank check (btrim(id) <> ''),
  constraint restaurant_categories_sort_order_nonnegative check (sort_order >= 0)
);

create index if not exists restaurant_categories_sort_order_idx
  on public.restaurant_categories (sort_order, id);

create table if not exists public.restaurants (
  id text primary key,
  name text not null,
  image_asset_path text not null,
  rating numeric(2, 1) not null,
  delivery_time_min_minutes integer not null,
  delivery_time_max_minutes integer not null,
  cuisine text not null,
  is_featured boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  constraint restaurants_id_lowercase check (id = lower(id)),
  constraint restaurants_id_not_blank check (btrim(id) <> ''),
  constraint restaurants_name_not_blank check (btrim(name) <> ''),
  constraint restaurants_image_asset_path_not_blank check (
    btrim(image_asset_path) <> ''
  ),
  constraint restaurants_rating_range check (rating >= 0 and rating <= 5),
  constraint restaurants_delivery_time_bounds check (
    delivery_time_min_minutes > 0
    and delivery_time_max_minutes >= delivery_time_min_minutes
  ),
  constraint restaurants_cuisine_not_blank check (btrim(cuisine) <> ''),
  constraint restaurants_sort_order_nonnegative check (sort_order >= 0)
);

create index if not exists restaurants_featured_sort_order_idx
  on public.restaurants (is_featured, sort_order, id);

create table if not exists public.restaurant_category_links (
  restaurant_id text not null references public.restaurants (id) on delete cascade,
  category_id text not null references public.restaurant_categories (id) on delete cascade,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  constraint restaurant_category_links_pkey primary key (restaurant_id, category_id),
  constraint restaurant_category_links_sort_order_nonnegative check (sort_order >= 0)
);

create index if not exists restaurant_category_links_category_id_idx
  on public.restaurant_category_links (category_id);

create table if not exists public.home_promotions (
  id text primary key,
  image_asset_path text not null,
  discount_percentage integer not null,
  is_free_delivery_enabled boolean not null default false,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  constraint home_promotions_id_lowercase check (id = lower(id)),
  constraint home_promotions_id_not_blank check (btrim(id) <> ''),
  constraint home_promotions_image_asset_path_not_blank check (
    btrim(image_asset_path) <> ''
  ),
  constraint home_promotions_discount_percentage_range check (
    discount_percentage >= 0 and discount_percentage <= 100
  ),
  constraint home_promotions_sort_order_nonnegative check (sort_order >= 0)
);

create index if not exists home_promotions_active_sort_order_idx
  on public.home_promotions (is_active, sort_order, id);

revoke all on public.restaurant_categories from anon;
revoke all on public.restaurants from anon;
revoke all on public.restaurant_category_links from anon;
revoke all on public.home_promotions from anon;
revoke all on public.restaurant_categories from authenticated;
revoke all on public.restaurants from authenticated;
revoke all on public.restaurant_category_links from authenticated;
revoke all on public.home_promotions from authenticated;
revoke all on public.restaurant_categories from service_role;
revoke all on public.restaurants from service_role;
revoke all on public.restaurant_category_links from service_role;
revoke all on public.home_promotions from service_role;

grant usage on schema public to authenticated;
grant usage on schema public to service_role;

grant select on public.restaurant_categories to authenticated;
grant select on public.restaurant_categories to service_role;
grant select on public.restaurants to authenticated;
grant select on public.restaurants to service_role;
grant select on public.restaurant_category_links to authenticated;
grant select on public.restaurant_category_links to service_role;
grant select on public.home_promotions to authenticated;
grant select on public.home_promotions to service_role;

alter table public.restaurant_categories enable row level security;
alter table public.restaurants enable row level security;
alter table public.restaurant_category_links enable row level security;
alter table public.home_promotions enable row level security;

drop policy if exists "Authenticated users can read restaurant categories"
  on public.restaurant_categories;
create policy "Authenticated users can read restaurant categories"
  on public.restaurant_categories
  for select
  to authenticated
  using (true);

drop policy if exists "Authenticated users can read restaurants"
  on public.restaurants;
create policy "Authenticated users can read restaurants"
  on public.restaurants
  for select
  to authenticated
  using (true);

drop policy if exists "Authenticated users can read restaurant category links"
  on public.restaurant_category_links;
create policy "Authenticated users can read restaurant category links"
  on public.restaurant_category_links
  for select
  to authenticated
  using (true);

drop policy if exists "Authenticated users can read home promotions"
  on public.home_promotions;
create policy "Authenticated users can read home promotions"
  on public.home_promotions
  for select
  to authenticated
  using (true);

insert into public.restaurant_categories (id, sort_order)
values
  ('all', 0),
  ('burgers', 1),
  ('pizza', 2),
  ('sushi', 3),
  ('healthy', 4)
on conflict (id) do update
set sort_order = excluded.sort_order;

insert into public.restaurants (
  id,
  name,
  image_asset_path,
  rating,
  delivery_time_min_minutes,
  delivery_time_max_minutes,
  cuisine,
  is_featured,
  sort_order
)
values
  (
    'burger_artisan_collective',
    'Burger Artisan Collective',
    'assets/images/branding/logo-flowdelivery-light.png',
    4.8,
    25,
    35,
    'american',
    true,
    0
  ),
  (
    'pasta_roma',
    'Pasta Roma',
    'assets/images/branding/logo-flowdelivery-light.png',
    4.6,
    30,
    45,
    'italian',
    true,
    1
  ),
  (
    'sushi_zen',
    'Sushi Zen',
    'assets/images/branding/logo-flowdelivery-light.png',
    4.9,
    20,
    30,
    'japanese',
    true,
    2
  ),
  (
    'taco_harbor',
    'Taco Harbor',
    'assets/images/branding/logo-flowdelivery-light.png',
    4.5,
    20,
    30,
    'mexican',
    true,
    3
  )
on conflict (id) do update
set
  name = excluded.name,
  image_asset_path = excluded.image_asset_path,
  rating = excluded.rating,
  delivery_time_min_minutes = excluded.delivery_time_min_minutes,
  delivery_time_max_minutes = excluded.delivery_time_max_minutes,
  cuisine = excluded.cuisine,
  is_featured = excluded.is_featured,
  sort_order = excluded.sort_order;

insert into public.restaurant_category_links (
  restaurant_id,
  category_id,
  sort_order
)
values
  ('burger_artisan_collective', 'all', 0),
  ('burger_artisan_collective', 'burgers', 1),
  ('pasta_roma', 'all', 0),
  ('pasta_roma', 'healthy', 1),
  ('sushi_zen', 'all', 0),
  ('sushi_zen', 'sushi', 1),
  ('taco_harbor', 'all', 0),
  ('taco_harbor', 'healthy', 1)
on conflict (restaurant_id, category_id) do update
set sort_order = excluded.sort_order;

insert into public.home_promotions (
  id,
  image_asset_path,
  discount_percentage,
  is_free_delivery_enabled,
  sort_order,
  is_active
)
values (
  'weekend_pizza_party',
  'assets/images/branding/logo-flowdelivery-light.png',
  30,
  true,
  0,
  true
)
on conflict (id) do update
set
  image_asset_path = excluded.image_asset_path,
  discount_percentage = excluded.discount_percentage,
  is_free_delivery_enabled = excluded.is_free_delivery_enabled,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;
