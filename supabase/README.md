# supabase

Supabase project artifacts belong here.

Expected examples:

- migrations
- seed data
- edge functions
- local Supabase notes

Home remote feed foundation:

- `migrations/20260601192000_home_remote_feed_foundation.sql` creates the read-only Home feed tables:
  - `public.restaurant_categories`
  - `public.restaurants`
  - `public.restaurant_category_links`
  - `public.home_promotions`
- The migration keeps bundled `image_asset_path` values for now and does not introduce Storage.
- Home feed tables must stay paired with explicit `authenticated`/`service_role` grants plus RLS; do not grant `anon`.
