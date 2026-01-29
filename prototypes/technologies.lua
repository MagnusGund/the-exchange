-- Technology Prototypes
-- Unlocks for the Incremental Industrialist mod

-- Base technology - unlocks the trade system
local trade_operations = {
  type = "technology",
  name = "ii-trade-operations",
  icon = "__base__/graphics/technology/logistics-1.png",
  icon_size = 256,
  effects = {
    {type = "unlock-recipe", recipe = "ii-trade-hub"},
    {type = "unlock-recipe", recipe = "ii-import-chest"},
    {type = "unlock-recipe", recipe = "ii-export-chest"},
  },
  prerequisites = {"automation-science-pack"},  -- Green science
  unit = {
    count = 100,
    ingredients = {
      {"automation-science-pack", 1},
    },
    time = 30,
  },
  order = "c-a-z[ii-trade-operations]",
}

-- Advanced imports - unlocks plate imports
local advanced_imports = {
  type = "technology",
  name = "ii-advanced-imports",
  icon = "__base__/graphics/technology/logistics-2.png",
  icon_size = 256,
  effects = {
    -- Effects handled in control.lua based on tech completion
  },
  prerequisites = {"ii-trade-operations", "logistic-science-pack"},
  unit = {
    count = 200,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30,
  },
  order = "c-a-z[ii-advanced-imports]",
}

-- Robot logistics bonus - unlocks robot upgrades in the shop
local robot_logistics_bonus = {
  type = "technology",
  name = "ii-robot-logistics-bonus",
  icon = "__base__/graphics/technology/robotics.png",
  icon_size = 256,
  effects = {
    -- Effects handled in control.lua - unlocks robot upgrades in shop
  },
  prerequisites = {"ii-trade-operations", "robotics"},
  unit = {
    count = 300,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1},
    },
    time = 45,
  },
  order = "c-a-z[ii-robot-logistics]",
}

data:extend({trade_operations, advanced_imports, robot_logistics_bonus})
