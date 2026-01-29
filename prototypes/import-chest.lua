-- Import Chest Entity and Item Prototypes
-- Generates resources and outputs to adjacent belts

local import_chest_entity = {
  type = "container",
  name = "ii-import-chest",
  icon = "__base__/graphics/icons/iron-chest.png",
  icon_size = 64,
  icons = {
    {icon = "__base__/graphics/icons/iron-chest.png", icon_size = 64},
    {icon = "__base__/graphics/icons/signal/signal_I.png", icon_size = 64, scale = 0.3, shift = {8, -8}, tint = {r = 0.2, g = 0.8, b = 0.2, a = 1}},
  },
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 0.3, result = "ii-import-chest"},
  max_health = 200,
  corpse = "small-remnants",
  dying_explosion = "iron-chest-explosion",
  open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.5},
  close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.5},
  inventory_size = 1,  -- Small buffer for spawned items
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

local import_chest_item = {
  type = "item",
  name = "ii-import-chest",
  icons = {
    {icon = "__base__/graphics/icons/iron-chest.png", icon_size = 64},
    {icon = "__base__/graphics/icons/signal/signal_I.png", icon_size = 64, scale = 0.3, shift = {8, -8}, tint = {r = 0.2, g = 0.8, b = 0.2, a = 1}},
  },
  icon_size = 64,
  subgroup = "storage",
  order = "a[items]-z[ii-import-chest]",
  place_result = "ii-import-chest",
  stack_size = 50,
}

local import_chest_recipe = {
  type = "recipe",
  name = "ii-import-chest",
  enabled = false,  -- Unlocked by technology
  energy_required = 2,
  ingredients = {
    {type = "item", name = "iron-plate", amount = 10},
    {type = "item", name = "electronic-circuit", amount = 5},
  },
  results = {{type = "item", name = "ii-import-chest", amount = 1}},
}

data:extend({import_chest_entity, import_chest_item, import_chest_recipe})
