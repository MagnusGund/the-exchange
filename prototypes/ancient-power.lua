-- The Exchange - Ancient Power System
-- Ancient Power Cells provide enhanced fusion power but consume fluoroketone
-- The generator consumes cold fluoroketone and outputs hot fluoroketone at 90% rate

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

-- Ancient Plasma Generator - burns Ancient Power Cells and processes fluoroketone
-- Uses burner-generator with runtime fluid handling for cold→hot conversion
data:extend({
  {
    type = "burner-generator",
    name = "ii-ancient-plasma-generator",
    icon = "__base__/graphics/icons/steam-engine.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "ii-ancient-plasma-generator"},
    max_health = 500,
    corpse = "steam-engine-remnants",
    dying_explosion = "steam-engine-explosion",
    max_power_output = "50MW",
    collision_box = {{-1.3, -2.3}, {1.3, 2.3}},
    selection_box = {{-1.5, -2.5}, {1.5, 2.5}},
    burner = {
      type = "burner",
      fuel_categories = {"ii-ancient-fuel"},
      effectivity = 1,
      fuel_inventory_size = 2,
      burnt_inventory_size = 0,
      emissions_per_minute = {},
      smoke = {}
    },
    energy_source = {
      type = "electric",
      usage_priority = "secondary-output"
    },
    animation = {
      north = {
        filename = "__base__/graphics/entity/steam-engine/steam-engine-V.png",
        width = 225,
        height = 391,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(4.75, -0.25),
        scale = 0.5
      },
      east = {
        filename = "__base__/graphics/entity/steam-engine/steam-engine-H.png",
        width = 352,
        height = 257,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, -4.5),
        scale = 0.5
      },
      south = {
        filename = "__base__/graphics/entity/steam-engine/steam-engine-V.png",
        width = 225,
        height = 391,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(4.75, -0.25),
        scale = 0.5
      },
      west = {
        filename = "__base__/graphics/entity/steam-engine/steam-engine-H.png",
        width = 352,
        height = 257,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, -4.5),
        scale = 0.5
      }
    },
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

-- Fluoroketone processor - handles cold→hot conversion with 10% loss
-- This is an assembler that the player places next to generators
data:extend({
  {
    type = "assembling-machine",
    name = "ii-fluoroketone-processor",
    icon = "__base__/graphics/icons/chemical-plant.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "ii-fluoroketone-processor"},
    max_health = 300,
    corpse = "chemical-plant-remnants",
    dying_explosion = "chemical-plant-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    crafting_categories = {"ii-fluoroketone-processing"},
    crafting_speed = 1,
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = {}
    },
    energy_usage = "500kW",
    fluid_boxes = {
      {
        volume = 200,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {{flow_direction = "input", direction = defines.direction.north, position = {0, -1}}},
        production_type = "input",
        filter = "fluoroketone-cold"
      },
      {
        volume = 200,
        pipe_covers = pipecoverspictures(),
        pipe_connections = {{flow_direction = "output", direction = defines.direction.south, position = {0, 1}}},
        production_type = "output",
        filter = "fluoroketone-hot"
      }
    },
    graphics_set = {
      animation = {
        north = {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
          width = 108,
          height = 148,
          frame_count = 1,
          shift = util.by_pixel(0, -9),
          scale = 0.5
        },
        east = {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
          width = 108,
          height = 148,
          frame_count = 1,
          shift = util.by_pixel(0, -9),
          scale = 0.5
        },
        south = {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
          width = 108,
          height = 148,
          frame_count = 1,
          shift = util.by_pixel(0, -9),
          scale = 0.5
        },
        west = {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
          width = 108,
          height = 148,
          frame_count = 1,
          shift = util.by_pixel(0, -9),
          scale = 0.5
        }
      }
    },
    working_sound = {
      sound = {filename = "__base__/sound/chemical-plant-3.ogg", volume = 0.5},
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },
    open_sound = {filename = "__base__/sound/open-close/fluid-open.ogg", volume = 0.6},
    close_sound = {filename = "__base__/sound/open-close/fluid-close.ogg", volume = 0.6}
  }
})

-- Fluoroketone processor item
data:extend({
  {
    type = "item",
    name = "ii-fluoroketone-processor",
    icon = "__base__/graphics/icons/chemical-plant.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "e[fluoroketone-processor]",
    place_result = "ii-fluoroketone-processor",
    stack_size = 10,
    weight = 10000
  }
})

-- Recipe category for fluoroketone processing
data:extend({
  {
    type = "recipe-category",
    name = "ii-fluoroketone-processing"
  }
})

-- Recipe: Process fluoroketone (cold → hot with 10% loss)
-- 100 cold → 90 hot, creating demand for imported fluoroketone
data:extend({
  {
    type = "recipe",
    name = "ii-process-fluoroketone",
    category = "ii-fluoroketone-processing",
    enabled = false,
    energy_required = 1,
    ingredients = {
      {type = "fluid", name = "fluoroketone-cold", amount = 100}
    },
    results = {
      {type = "fluid", name = "fluoroketone-hot", amount = 90}
    },
    allow_productivity = false,
    hide_from_player_crafting = true,
    surface_conditions = {
      {
        property = "ii-exchange-property",
        min = 1
      }
    }
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

-- Recipe: Fluoroketone Processor
data:extend({
  {
    type = "recipe",
    name = "ii-fluoroketone-processor",
    category = "crafting",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "steel-plate", amount = 20},
      {type = "item", name = "processing-unit", amount = 5},
      {type = "item", name = "pipe", amount = 20}
    },
    results = {
      {type = "item", name = "ii-fluoroketone-processor", amount = 1}
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
      {type = "unlock-recipe", recipe = "ii-ancient-plasma-generator"},
      {type = "unlock-recipe", recipe = "ii-fluoroketone-processor"},
      {type = "unlock-recipe", recipe = "ii-process-fluoroketone"}
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
