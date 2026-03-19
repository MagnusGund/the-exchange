-- The Exchange - Import Chest
-- Generates materials from credits, outputs to belts

data:extend({
  -- Item
  {
    type = "item",
    name = "ii-import-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64,
    subgroup = "storage",
    order = "a[items]-d[ii-import-chest]",
    place_result = "ii-import-chest",
    stack_size = 50,
    weight = 10000
  },
  
  -- Entity (container with loader output behavior)
  {
    type = "container",
    name = "ii-import-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.2, result = "ii-import-chest"},
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

-- Tint the import chest icon to distinguish it (blue tint)
local import_item = data.raw["item"]["ii-import-chest"]
if import_item then
  import_item.icons = {
    {
      icon = "__base__/graphics/icons/steel-chest.png",
      icon_size = 64,
      tint = {r = 0.6, g = 0.8, b = 1.0, a = 1.0}
    }
  }
  import_item.icon = nil
  import_item.icon_size = nil
end

local import_entity = data.raw["container"]["ii-import-chest"]
if import_entity then
  import_entity.icons = {
    {
      icon = "__base__/graphics/icons/steel-chest.png",
      icon_size = 64,
      tint = {r = 0.6, g = 0.8, b = 1.0, a = 1.0}
    }
  }
  import_entity.icon = nil
  import_entity.icon_size = nil
end
