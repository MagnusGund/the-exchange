-- The Exchange - Ancient Power System
-- Ancient Power Cells provide enhanced fusion power but consume fluoroketone

-- Ancient Power Cell item
data:extend({
  {
    type = "item",
    name = "ii-ancient-power-cell",
    icon = "__base__/graphics/icons/nuclear-fuel.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "c[ancient-power-cell]",
    stack_size = 50,
    weight = 5000,
    fuel_category = "ii-ancient-fuel",
    fuel_value = "12GJ",  -- 3x the base fusion cell value (~4GJ)
    fuel_acceleration_multiplier = 1.0,
    fuel_top_speed_multiplier = 1.0
  }
})

-- Ancient fuel category (used only by Ancient Plasma Generator)
data:extend({
  {
    type = "fuel-category",
    name = "ii-ancient-fuel"
  }
})

-- Ancient Plasma Generator - consumes Ancient Power Cells + Fluoroketone
-- This is a generator that burns ancient fuel and requires fluoroketone fluid input
data:extend({
  {
    type = "generator",
    name = "ii-ancient-plasma-generator",
    icon = "__base__/graphics/icons/steam-engine.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "ii-ancient-plasma-generator"},
    max_health = 500,
    corpse = "steam-engine-remnants",
    dying_explosion = "steam-engine-explosion",
    effectivity = 1,
    fluid_usage_per_tick = 0.5,  -- Fluoroketone consumption rate
    maximum_temperature = 165,   -- Cold fluoroketone temp
    burns_fluid = false,
    scale_fluid_usage = true,
    destroy_non_fuel_fluid = false,
    max_power_output = "50MW",   -- Very powerful output
    collision_box = {{-1.3, -2.3}, {1.3, 2.3}},
    selection_box = {{-1.5, -2.5}, {1.5, 2.5}},
    fluid_box = {
      volume = 200,
      pipe_covers = pipecoverspictures(),
      pipe_connections = {
        {flow_direction = "input-output", direction = defines.direction.north, position = {0, -2}},
        {flow_direction = "input-output", direction = defines.direction.south, position = {0, 2}}
      },
      production_type = "input-output",
      filter = "fluoroketone-cold"
    },
    energy_source = {
      type = "burner",
      fuel_categories = {"ii-ancient-fuel"},
      effectivity = 3.0,  -- 3x efficiency multiplier
      fuel_inventory_size = 2,
      burnt_inventory_size = 0,
      emissions_per_minute = {},
      smoke = {}
    },
    horizontal_animation = {
      filename = "__base__/graphics/entity/steam-engine/steam-engine-H.png",
      width = 352,
      height = 257,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, -4.5),
      scale = 0.5
    },
    vertical_animation = {
      filename = "__base__/graphics/entity/steam-engine/steam-engine-V.png",
      width = 225,
      height = 391,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(4.75, -0.25),
      scale = 0.5
    },
    smoke = {},
    working_sound = {
      sound = {filename = "__base__/sound/steam-engine-90bpm.ogg", volume = 0.6},
      match_speed_to_activity = true
    },
    min_perceived_performance = 0.25,
    performance_to_sound_speedup = 0.5,
    open_sound = {filename = "__base__/sound/open-close/steam-open.ogg", volume = 0.6},
    close_sound = {filename = "__base__/sound/open-close/steam-close.ogg", volume = 0.6}
  }
})

-- Ancient Plasma Generator item
data:extend({
  {
    type = "item",
    name = "ii-ancient-plasma-generator",
    icon = "__base__/graphics/icons/steam-engine.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "d[ancient-plasma-generator]",
    place_result = "ii-ancient-plasma-generator",
    stack_size = 10,
    weight = 20000
  }
})

-- Recipe: Ancient Power Cell (fusion cell + exchange data)
data:extend({
  {
    type = "recipe",
    name = "ii-ancient-power-cell",
    category = "crafting",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "fusion-power-cell", amount = 1},
      {type = "item", name = "ii-exchange-data", amount = 10}
    },
    results = {
      {type = "item", name = "ii-ancient-power-cell", amount = 1}
    },
    allow_productivity = false,
    surface_conditions = {
      {
        property = "ii-exchange-property",
        min = 1
      }
    }
  }
})

-- Recipe: Ancient Plasma Generator
data:extend({
  {
    type = "recipe",
    name = "ii-ancient-plasma-generator",
    category = "crafting",
    enabled = false,
    energy_required = 15,
    ingredients = {
      {type = "item", name = "fusion-generator", amount = 1},
      {type = "item", name = "ii-data-matrix", amount = 20},
      {type = "item", name = "processing-unit", amount = 10},
      {type = "item", name = "low-density-structure", amount = 20}
    },
    results = {
      {type = "item", name = "ii-ancient-plasma-generator", amount = 1}
    },
    surface_conditions = {
      {
        property = "ii-exchange-property",
        min = 1
      }
    }
  }
})

-- Technology: Ancient Power
data:extend({
  {
    type = "technology",
    name = "ii-ancient-power",
    icon = "__base__/graphics/technology/nuclear-power.png",
    icon_size = 256,
    effects = {
      {type = "unlock-recipe", recipe = "ii-ancient-power-cell"},
      {type = "unlock-recipe", recipe = "ii-ancient-plasma-generator"}
    },
    prerequisites = {"ii-commerce-science", "fusion-reactor"},
    unit = {
      count = 1000,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"ii-commerce-science-pack", 1}
      },
      time = 60
    },
    order = "z-d-a"
  }
})
