-- Incremental Industrialist - Data Terminal
-- Converts credits to Exchange Data with scaling cost

data:extend({
  -- Item
  {
    type = "item",
    name = "ii-data-terminal",
    icon = "__base__/graphics/icons/roboport.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "z[ii-data-terminal]",
    place_result = "ii-data-terminal",
    stack_size = 10,
    weight = 50000
  },
  
  -- Entity (assembling machine that "crafts" Exchange Data from credits)
  {
    type = "assembling-machine",
    name = "ii-data-terminal",
    icon = "__base__/graphics/icons/roboport.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "ii-data-terminal"},
    max_health = 500,
    corpse = "roboport-remnants",
    dying_explosion = "roboport-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    drawing_box_vertical_extension = 1,
    fast_replaceable_group = "ii-data-terminal",
    
    graphics_set = {
      animation = {
        layers = {
          {
            filename = "__base__/graphics/entity/roboport/roboport-base.png",
            width = 228,
            height = 277,
            shift = util.by_pixel(2, -11),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/entity/roboport/roboport-shadow.png",
            width = 294,
            height = 201,
            draw_as_shadow = true,
            shift = util.by_pixel(28.5, 14.25),
            scale = 0.5
          }
        }
      }
    },
    
    open_sound = {filename = "__base__/sound/open-close/roboport-open.ogg", volume = 0.6},
    close_sound = {filename = "__base__/sound/open-close/roboport-close.ogg", volume = 0.6},
    working_sound = {
      sound = {
        filename = "__base__/sound/roboport-working.ogg",
        volume = 0.5
      },
      max_sounds_per_type = 3,
      audible_distance_modifier = 0.5
    },
    
    crafting_categories = {"ii-data-conversion"},
    crafting_speed = 1,
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      buffer_capacity = "10MJ",
      input_flow_limit = "1MW",
      drain = "10kW"
    },
    energy_usage = "200kW",
    allowed_effects = {"consumption", "speed", "pollution"},
    module_slots = 2
  }
})

-- Custom crafting category for data terminal
data:extend({
  {
    type = "recipe-category",
    name = "ii-data-conversion"
  }
})

-- Recipe for "converting" - this is a dummy recipe, actual conversion happens in control.lua
data:extend({
  {
    type = "recipe",
    name = "ii-credit-to-data",
    category = "ii-data-conversion",
    enabled = false,
    hidden = true,
    energy_required = 1,
    ingredients = {},
    results = {
      {type = "item", name = "ii-exchange-data", amount = 1}
    }
  }
})

-- Tint the data terminal icon (purple tint)
local terminal_item = data.raw["item"]["ii-data-terminal"]
if terminal_item then
  terminal_item.icons = {
    {
      icon = "__base__/graphics/icons/roboport.png",
      icon_size = 64,
      tint = {r = 0.8, g = 0.5, b = 1.0, a = 1.0}
    }
  }
  terminal_item.icon = nil
  terminal_item.icon_size = nil
end

local terminal_entity = data.raw["assembling-machine"]["ii-data-terminal"]
if terminal_entity then
  terminal_entity.icons = {
    {
      icon = "__base__/graphics/icons/roboport.png",
      icon_size = 64,
      tint = {r = 0.8, g = 0.5, b = 1.0, a = 1.0}
    }
  }
  terminal_entity.icon = nil
  terminal_entity.icon_size = nil
end
