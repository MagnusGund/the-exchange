-- The Exchange - Export Chest
-- Accepts products to fulfill orders and earn credits

data:extend({
  -- Item
  {
    type = "item",
    name = "ii-export-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64,
    subgroup = "storage",
    order = "a[items]-e[ii-export-chest]",
    place_result = "ii-export-chest",
    stack_size = 50,
    weight = 10000
  },
  
  -- Entity (container that accepts items for export)
  {
    type = "container",
    name = "ii-export-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.2, result = "ii-export-chest"},
    max_health = 350,
    corpse = "steel-chest-remnants",
    dying_explosion = "steel-chest-explosion",
    open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.5},
    close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.5},
    resistances = {
      {type = "fire", percent = 90},
      {type = "impact", percent = 60}
    },
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fast_replaceable_group = "container",
    inventory_size = 48,
    inventory_type = "with_filters_and_bar",
    picture = {
      layers = {
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
          priority = "extra-high",
          width = 64,
          height = 80,
          shift = util.by_pixel(0, -3.5),
          scale = 0.5
        },
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest-shadow.png",
          priority = "extra-high",
          width = 110,
          height = 46,
          shift = util.by_pixel(12.5, 8),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    },
    circuit_connector = circuit_connector_definitions["chest"],
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }
})

-- Tint the export chest icon to distinguish it (orange tint)
local export_item = data.raw["item"]["ii-export-chest"]
if export_item then
  export_item.icons = {
    {
      icon = "__base__/graphics/icons/steel-chest.png",
      icon_size = 64,
      tint = {r = 1.0, g = 0.7, b = 0.4, a = 1.0}
    }
  }
  export_item.icon = nil
  export_item.icon_size = nil
end

local export_entity = data.raw["container"]["ii-export-chest"]
if export_entity then
  export_entity.icons = {
    {
      icon = "__base__/graphics/icons/steel-chest.png",
      icon_size = 64,
      tint = {r = 1.0, g = 0.7, b = 0.4, a = 1.0}
    }
  }
  export_entity.icon = nil
  export_entity.icon_size = nil
end
