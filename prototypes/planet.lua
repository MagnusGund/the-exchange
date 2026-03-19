-- The Exchange - Planet Definition

local planet_map_gen = require("__space-age__/prototypes/planet/planet-map-gen")

-- The Exchange planet surface conditions
data:extend({
  {
    type = "surface-property",
    name = "ii-exchange-property",
    default_value = 0,
    is_time = false,
    localised_name = {"surface-property-name.ii-exchange-property"},
    localised_description = {"surface-property-description.ii-exchange-property"}
  }
})

-- The Exchange planet definition
-- Custom map generation for megastructure floor (concrete-based)
local exchange_map_gen = {
  terrain_segmentation = 1,
  water = 0,
  autoplace_controls = {},
  autoplace_settings = {
    entity = {settings = {}},
    tile = {
      settings = {
        ["ii-exchange-floor"] = {},
        ["ii-exchange-floor-dark"] = {}
      }
    },
    decorative = {settings = {}}
  },
  cliff_settings = {cliff_elevation_0 = 1024},  -- No cliffs
  property_expression_names = {
    moisture = 0,
    aux = 0,
    temperature = 25,
    cliffiness = 0
  },
  starting_area = 1
}

data:extend({
  {
    type = "planet",
    name = "ii-the-exchange",
    icon = "__base__/graphics/icons/nauvis.png",
    icon_size = 64,
    starmap_icon = "__base__/graphics/icons/nauvis.png",
    starmap_icon_size = 64,
    gravity_pull = 10,
    distance = 20,
    orientation = 0.3,
    magnitude = 1.0,
    order = "z[incremental]-a[exchange]",
    subgroup = "planets",
    map_gen_settings = exchange_map_gen,
    pollutant_type = nil,
    solar_power_in_space = 100,
    platform_procession_set = {
      arrival = {"default-rocket-a"},
      departure = {"default-rocket-a"}
    },
    persistent_ambient_sounds = {},
    surface_properties = {
      ["day-night-cycle"] = 0, -- Always day
      pressure = 1000,
      gravity = 10,
      ["ii-exchange-property"] = 1
    },
    asteroid_spawn_influence = 0,
    asteroid_spawn_definitions = {},
    surface_render_parameters = {
      fog = {
        fog_type = "none"
      }
    }
  },
  -- Space connection from Nauvis to The Exchange
  {
    type = "space-connection",
    name = "nauvis-ii-the-exchange",
    subgroup = "planet-connections",
    from = "nauvis",
    to = "ii-the-exchange",
    order = "z-a",
    length = 15000,
    asteroid_spawn_definitions = {}
  }
})

-- Exchange planet tiles - ancient megastructure flooring
-- Main floor tile (lighter, more common)
data:extend({
  {
    type = "tile",
    name = "ii-exchange-floor",
    order = "z-a",
    subgroup = "nauvis-tiles",
    collision_mask = {layers = {ground_tile = true}},
    layer = 50,
    variants = {
      main = {
        {
          picture = "__base__/graphics/terrain/concrete/refined-concrete.png",
          count = 16,
          size = 1,
          scale = 0.5
        }
      },
      empty_transitions = true
    },
    map_color = {r = 0.35, g = 0.42, b = 0.5},
    walking_speed_modifier = 1.3,  -- Smooth ancient flooring
    vehicle_friction_modifier = 0.7,
    decorative_removal_probability = 1.0,
    absorptions_per_second = {},
    minable = nil,
    mined_sound = nil,
    walking_sound = {
      {filename = "__base__/sound/walking/concrete-01.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-02.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-03.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-04.ogg", volume = 0.5}
    },
    autoplace = {
      probability_expression = "0.7"  -- 70% of surface
    }
  },
  -- Dark floor variant (accent/structure panels)
  {
    type = "tile",
    name = "ii-exchange-floor-dark",
    order = "z-b",
    subgroup = "nauvis-tiles",
    collision_mask = {layers = {ground_tile = true}},
    layer = 51,
    variants = {
      main = {
        {
          picture = "__base__/graphics/terrain/concrete/refined-concrete.png",
          count = 16,
          size = 1,
          scale = 0.5,
          tint = {r = 0.6, g = 0.65, b = 0.7}
        }
      },
      empty_transitions = true
    },
    map_color = {r = 0.25, g = 0.30, b = 0.38},
    walking_speed_modifier = 1.3,
    vehicle_friction_modifier = 0.7,
    decorative_removal_probability = 1.0,
    absorptions_per_second = {},
    minable = nil,
    mined_sound = nil,
    walking_sound = {
      {filename = "__base__/sound/walking/concrete-01.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-02.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-03.ogg", volume = 0.5},
      {filename = "__base__/sound/walking/concrete-04.ogg", volume = 0.5}
    },
    autoplace = {
      probability_expression = "0.3"  -- 30% of surface for variety
    }
  }
})
