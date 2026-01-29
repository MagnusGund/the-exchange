-- Export Chest Entity and Item Prototypes
-- Accepts products from belts to fulfill orders

local export_chest_entity = {
  type = "container",
  name = "ii-export-chest",
  icon = "__base__/graphics/icons/iron-chest.png",
  icon_size = 64,
  icons = {
    {icon = "__base__/graphics/icons/iron-chest.png", icon_size = 64},
    {icon = "__base__/graphics/icons/signal/signal_E.png", icon_size = 64, scale = 0.3, shift = {8, -8}, tint = {r = 0.8, g = 0.2, b = 0.2, a = 1}},
  },
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 0.3, result = "ii-export-chest"},
  max_health = 200,
  corpse = "small-remnants",
  dying_explosion = "iron-chest-explosion",
  open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.5},
  close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.5},
  inventory_size = 48,  -- Larger buffer for incoming products
  picture = {
    layers = {
      {
        filename = "__base__/graphics/entity/iron-chest/iron-chest.png",
        priority = "extra-high",
        width = 66,
        height = 76,
        shift = util.by_pixel(0, -2),
      },
    },
  },
  collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  fast_replaceable_group = "container",
}

local export_chest_item = {
  type = "item",
  name = "ii-export-chest",
  icons = {
    {icon = "__base__/graphics/icons/iron-chest.png", icon_size = 64},
    {icon = "__base__/graphics/icons/signal/signal_E.png", icon_size = 64, scale = 0.3, shift = {8, -8}, tint = {r = 0.8, g = 0.2, b = 0.2, a = 1}},
  },
  icon_size = 64,
  subgroup = "storage",
  order = "a[items]-z[ii-export-chest]",
  place_result = "ii-export-chest",
  stack_size = 50,
}

local export_chest_recipe = {
  type = "recipe",
  name = "ii-export-chest",
  enabled = false,  -- Unlocked by technology
  energy_required = 2,
  ingredients = {
    {type = "item", name = "iron-plate", amount = 10},
    {type = "item", name = "electronic-circuit", amount = 5},
  },
  results = {{type = "item", name = "ii-export-chest", amount = 1}},
}

data:extend({export_chest_entity, export_chest_item, export_chest_recipe})
