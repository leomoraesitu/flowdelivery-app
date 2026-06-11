insert into public.restaurant_menu_categories (
  restaurant_id,
  id,
  sort_order
)
values
  ('pasta_roma', 'popular', 0),
  ('pasta_roma', 'pastas', 1),
  ('pasta_roma', 'salads', 2),
  ('sushi_zen', 'popular', 0),
  ('sushi_zen', 'rolls', 1),
  ('sushi_zen', 'bowls', 2),
  ('taco_harbor', 'popular', 0),
  ('taco_harbor', 'tacos', 1),
  ('taco_harbor', 'sides', 2)
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
    'pasta_roma_nonna_lasagna',
    'pasta_roma',
    'popular',
    'Nonna Lasagna',
    'Layered pasta with slow-cooked beef ragu, mozzarella, and basil.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1680,
    0
  ),
  (
    'pasta_roma_truffle_tagliatelle',
    'pasta_roma',
    'pastas',
    'Truffle Tagliatelle',
    'Fresh tagliatelle with parmesan cream, mushrooms, and truffle oil.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1720,
    0
  ),
  (
    'pasta_roma_pomodoro_rigatoni',
    'pasta_roma',
    'pastas',
    'Pomodoro Rigatoni',
    'Rigatoni tossed with San Marzano tomato sauce, garlic, and basil.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1390,
    1
  ),
  (
    'pasta_roma_caprese_salad',
    'pasta_roma',
    'salads',
    'Caprese Salad',
    'Fresh mozzarella, tomatoes, basil, olive oil, and balsamic glaze.',
    'assets/images/branding/logo-flowdelivery-light.png',
    980,
    0
  ),
  (
    'sushi_zen_omakase_sampler',
    'sushi_zen',
    'popular',
    'Omakase Sampler',
    'Chef-selected nigiri and rolls with seasonal garnish and soy.',
    'assets/images/branding/logo-flowdelivery-light.png',
    2490,
    0
  ),
  (
    'sushi_zen_salmon_avocado_roll',
    'sushi_zen',
    'rolls',
    'Salmon Avocado Roll',
    'Fresh salmon, avocado, cucumber, sesame, and sushi rice.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1390,
    0
  ),
  (
    'sushi_zen_spicy_tuna_roll',
    'sushi_zen',
    'rolls',
    'Spicy Tuna Roll',
    'Tuna, chili mayo, scallions, cucumber, and toasted sesame.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1450,
    1
  ),
  (
    'sushi_zen_chirashi_bowl',
    'sushi_zen',
    'bowls',
    'Chirashi Bowl',
    'Assorted sashimi over seasoned rice with nori and pickled ginger.',
    'assets/images/branding/logo-flowdelivery-light.png',
    2190,
    0
  ),
  (
    'taco_harbor_al_pastor',
    'taco_harbor',
    'popular',
    'Al Pastor Tacos',
    'Marinated pork, pineapple, cilantro, onion, and corn tortillas.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1290,
    0
  ),
  (
    'taco_harbor_shrimp_tacos',
    'taco_harbor',
    'tacos',
    'Baja Shrimp Tacos',
    'Crispy shrimp, cabbage slaw, lime crema, and pico de gallo.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1490,
    0
  ),
  (
    'taco_harbor_carne_asada_tacos',
    'taco_harbor',
    'tacos',
    'Carne Asada Tacos',
    'Grilled steak, salsa verde, onions, cilantro, and corn tortillas.',
    'assets/images/branding/logo-flowdelivery-light.png',
    1520,
    1
  ),
  (
    'taco_harbor_elote_cup',
    'taco_harbor',
    'sides',
    'Elote Cup',
    'Sweet corn with cotija, chili, lime, crema, and cilantro.',
    'assets/images/branding/logo-flowdelivery-light.png',
    690,
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
