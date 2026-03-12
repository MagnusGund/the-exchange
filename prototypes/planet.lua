-- Incremental Industrialist - The Exchange Planet

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
    map_gen_settings = planet_map_gen.nauvis(),
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

-- Exchange planet tiles (simple concrete-like surface)
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
          picture = "__base__/graphics/terrain/concrete/concrete-dummy.png",
          count = 1,
          size = 1
        }
      },
      empty_transitions = true
    },
    map_color = {r = 0.3, g = 0.4, b = 0.5},
    walking_speed_modifier = 1.2,
    vehicle_friction_modifier = 0.8,
    decorative_removal_probability = 1.0,
    minable = nil,
    mined_sound = nil,
    walking_sound = {
      {
        filename = "__base__/sound/walking/concrete-01.ogg",
        volume = 0.5
      },
      {
        filename = "__base__/sound/walking/concrete-02.ogg",
        volume = 0.5
      },
      {
        filename = "__base__/sound/walking/concrete-03.ogg",
        volume = 0.5
      },
      {
        filename = "__base__/sound/walking/concrete-04.ogg",
        volume = 0.5
      }
    }
  }
})
