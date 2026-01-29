-- Trade Hub Entity and Item Prototypes
-- The central building for managing the incremental trade system

local trade_hub_entity = {
  type = "container",
  name = "ii-trade-hub",
  icon = "__incremental-industrialist__/graphics/icons/trade-hub.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 0.5, result = "ii-trade-hub"},
  max_health = 500,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",
  open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.5},
  close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.5},
  inventory_size = 0,  -- No inventory, just a marker entity
  picture = {
    layers = {
      {
        filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
        priority = "extra-high",
        width = 64,
        height = 80,
        shift = util.by_pixel(0, -8),
        scale = 1.5,
      },
    },
  },
  collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
  selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
  fast_replaceable_group = "container",
}

local trade_hub_item = {
  type = "item",
  name = "ii-trade-hub",
  icon = "__incremental-industrialist__/graphics/icons/trade-hub.png",
  icon_size = 64,
  subgroup = "storage",
  order = "a[items]-z[ii-trade-hub]",
  place_result = "ii-trade-hub",
  stack_size = 1,
}

local trade_hub_recipe = {
  type = "recipe",
  name = "ii-trade-hub",
  enabled = false,  -- Unlocked by technology
  energy_required = 10,
  ingredients = {
    {type = "item", name = "steel-plate", amount = 50},
    {type = "item", name = "electronic-circuit", amount = 50},
    {type = "item", name = "iron-gear-wheel", amount = 30},
  },
  results = {{type = "item", name = "ii-trade-hub", amount = 1}},
}

-- Use placeholder icon until real graphics are created
-- For now, tint an existing icon
trade_hub_entity.icon = "__base__/graphics/icons/steel-chest.png"
trade_hub_item.icon = "__base__/graphics/icons/steel-chest.png"
trade_hub_item.icons = {
  {icon = "__base__/graphics/icons/steel-chest.png", icon_size = 64},
  {icon = "__base__/graphics/icons/signal/signal_T.png", icon_size = 64, scale = 0.3, shift = {8, -8}},
}
trade_hub_entity.icons = trade_hub_item.icons

data:extend({trade_hub_entity, trade_hub_item, trade_hub_recipe})
