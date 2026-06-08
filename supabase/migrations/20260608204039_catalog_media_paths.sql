do $$
declare
  restaurant_row_count integer;
  product_row_count integer;
  promotion_path_before text;
begin
  select image_asset_path
  into strict promotion_path_before
  from public.home_promotions
  where id = 'weekend_pizza_party';

  if (
    select count(*)
    from storage.objects
    where bucket_id = 'catalog-media'
      and name in (
        'restaurants/burger_artisan_collective/cover.webp',
        'restaurants/pasta_roma/cover.webp',
        'restaurants/sushi_zen/cover.webp',
        'restaurants/taco_harbor/cover.webp',
        'products/burger_artisan_collective/signature_truffle.webp',
        'products/burger_artisan_collective/spicy_nashville_chicken.webp',
        'products/burger_artisan_collective/sweet_potato_crisp.webp',
        'products/burger_artisan_collective/artisan_milkshake.webp',
        'products/pasta_roma/pasta_roma_nonna_lasagna.webp',
        'products/pasta_roma/pasta_roma_truffle_tagliatelle.webp',
        'products/pasta_roma/pasta_roma_pomodoro_rigatoni.webp',
        'products/pasta_roma/pasta_roma_caprese_salad.webp',
        'products/sushi_zen/sushi_zen_omakase_sampler.webp',
        'products/sushi_zen/sushi_zen_salmon_avocado_roll.webp',
        'products/sushi_zen/sushi_zen_spicy_tuna_roll.webp',
        'products/sushi_zen/sushi_zen_chirashi_bowl.webp',
        'products/taco_harbor/taco_harbor_al_pastor.webp',
        'products/taco_harbor/taco_harbor_shrimp_tacos.webp',
        'products/taco_harbor/taco_harbor_carne_asada_tacos.webp',
        'products/taco_harbor/taco_harbor_elote_cup.webp'
      )
  ) <> 20 then
    raise exception
      'Expected all 20 catalog-media objects to exist before updating paths';
  end if;

  if (
    select count(*)
    from public.restaurants
    where id in (
      'burger_artisan_collective',
      'pasta_roma',
      'sushi_zen',
      'taco_harbor'
    )
  ) <> 4 then
    raise exception 'Expected all 4 target restaurants to exist';
  end if;

  if (
    select count(*)
    from public.restaurant_menu_items
    where (id, restaurant_id) in (
      ('signature_truffle', 'burger_artisan_collective'),
      ('spicy_nashville_chicken', 'burger_artisan_collective'),
      ('sweet_potato_crisp', 'burger_artisan_collective'),
      ('artisan_milkshake', 'burger_artisan_collective'),
      ('pasta_roma_nonna_lasagna', 'pasta_roma'),
      ('pasta_roma_truffle_tagliatelle', 'pasta_roma'),
      ('pasta_roma_pomodoro_rigatoni', 'pasta_roma'),
      ('pasta_roma_caprese_salad', 'pasta_roma'),
      ('sushi_zen_omakase_sampler', 'sushi_zen'),
      ('sushi_zen_salmon_avocado_roll', 'sushi_zen'),
      ('sushi_zen_spicy_tuna_roll', 'sushi_zen'),
      ('sushi_zen_chirashi_bowl', 'sushi_zen'),
      ('taco_harbor_al_pastor', 'taco_harbor'),
      ('taco_harbor_shrimp_tacos', 'taco_harbor'),
      ('taco_harbor_carne_asada_tacos', 'taco_harbor'),
      ('taco_harbor_elote_cup', 'taco_harbor')
    )
  ) <> 16 then
    raise exception
      'Expected all 16 target products with approved restaurant ownership';
  end if;

  update public.restaurants as restaurant
  set image_asset_path = media.object_path
  from (
    values
      (
        'burger_artisan_collective',
        'restaurants/burger_artisan_collective/cover.webp'
      ),
      ('pasta_roma', 'restaurants/pasta_roma/cover.webp'),
      ('sushi_zen', 'restaurants/sushi_zen/cover.webp'),
      ('taco_harbor', 'restaurants/taco_harbor/cover.webp')
  ) as media(id, object_path)
  where restaurant.id = media.id;

  get diagnostics restaurant_row_count = row_count;

  if restaurant_row_count <> 4 then
    raise exception
      'Expected to update 4 restaurants, updated %',
      restaurant_row_count;
  end if;

  update public.restaurant_menu_items as item
  set image_asset_path = media.object_path
  from (
    values
      (
        'signature_truffle',
        'burger_artisan_collective',
        'products/burger_artisan_collective/signature_truffle.webp'
      ),
      (
        'spicy_nashville_chicken',
        'burger_artisan_collective',
        'products/burger_artisan_collective/spicy_nashville_chicken.webp'
      ),
      (
        'sweet_potato_crisp',
        'burger_artisan_collective',
        'products/burger_artisan_collective/sweet_potato_crisp.webp'
      ),
      (
        'artisan_milkshake',
        'burger_artisan_collective',
        'products/burger_artisan_collective/artisan_milkshake.webp'
      ),
      (
        'pasta_roma_nonna_lasagna',
        'pasta_roma',
        'products/pasta_roma/pasta_roma_nonna_lasagna.webp'
      ),
      (
        'pasta_roma_truffle_tagliatelle',
        'pasta_roma',
        'products/pasta_roma/pasta_roma_truffle_tagliatelle.webp'
      ),
      (
        'pasta_roma_pomodoro_rigatoni',
        'pasta_roma',
        'products/pasta_roma/pasta_roma_pomodoro_rigatoni.webp'
      ),
      (
        'pasta_roma_caprese_salad',
        'pasta_roma',
        'products/pasta_roma/pasta_roma_caprese_salad.webp'
      ),
      (
        'sushi_zen_omakase_sampler',
        'sushi_zen',
        'products/sushi_zen/sushi_zen_omakase_sampler.webp'
      ),
      (
        'sushi_zen_salmon_avocado_roll',
        'sushi_zen',
        'products/sushi_zen/sushi_zen_salmon_avocado_roll.webp'
      ),
      (
        'sushi_zen_spicy_tuna_roll',
        'sushi_zen',
        'products/sushi_zen/sushi_zen_spicy_tuna_roll.webp'
      ),
      (
        'sushi_zen_chirashi_bowl',
        'sushi_zen',
        'products/sushi_zen/sushi_zen_chirashi_bowl.webp'
      ),
      (
        'taco_harbor_al_pastor',
        'taco_harbor',
        'products/taco_harbor/taco_harbor_al_pastor.webp'
      ),
      (
        'taco_harbor_shrimp_tacos',
        'taco_harbor',
        'products/taco_harbor/taco_harbor_shrimp_tacos.webp'
      ),
      (
        'taco_harbor_carne_asada_tacos',
        'taco_harbor',
        'products/taco_harbor/taco_harbor_carne_asada_tacos.webp'
      ),
      (
        'taco_harbor_elote_cup',
        'taco_harbor',
        'products/taco_harbor/taco_harbor_elote_cup.webp'
      )
  ) as media(id, restaurant_id, object_path)
  where item.id = media.id
    and item.restaurant_id = media.restaurant_id;

  get diagnostics product_row_count = row_count;

  if product_row_count <> 16 then
    raise exception
      'Expected to update 16 products, updated %',
      product_row_count;
  end if;

  if exists (
    select 1
    from public.restaurants
    where id in (
      'burger_artisan_collective',
      'pasta_roma',
      'sushi_zen',
      'taco_harbor'
    )
      and image_asset_path not like 'restaurants/%/cover.webp'
  ) then
    raise exception 'A target restaurant has an invalid catalog-media path';
  end if;

  if exists (
    select 1
    from public.restaurant_menu_items
    where id in (
      'signature_truffle',
      'spicy_nashville_chicken',
      'sweet_potato_crisp',
      'artisan_milkshake',
      'pasta_roma_nonna_lasagna',
      'pasta_roma_truffle_tagliatelle',
      'pasta_roma_pomodoro_rigatoni',
      'pasta_roma_caprese_salad',
      'sushi_zen_omakase_sampler',
      'sushi_zen_salmon_avocado_roll',
      'sushi_zen_spicy_tuna_roll',
      'sushi_zen_chirashi_bowl',
      'taco_harbor_al_pastor',
      'taco_harbor_shrimp_tacos',
      'taco_harbor_carne_asada_tacos',
      'taco_harbor_elote_cup'
    )
      and image_asset_path not like 'products/%/%.webp'
  ) then
    raise exception 'A target product has an invalid catalog-media path';
  end if;

  if (
    select image_asset_path
    from public.home_promotions
    where id = 'weekend_pizza_party'
  ) is distinct from promotion_path_before then
    raise exception 'Home promotion media changed unexpectedly';
  end if;
end
$$;
