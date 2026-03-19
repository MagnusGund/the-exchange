-- The Exchange - Technologies
-- Research tree for unlocking mod features and infinite bonuses

data:extend({
  -- Planet Discovery: The Exchange (unlocks travel to the planet)
  {
    type = "technology",
    name = "ii-planet-discovery",
    icon = "__base__/graphics/technology/rocket-silo.png",
    icon_size = 256,
    effects = {
      {type = "unlock-space-location", space_location = "ii-the-exchange"}
    },
    prerequisites = {"space-science-pack"},
    unit = {
      count = 500,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 60
    },
    order = "z-a-0"
  },

  -- Base technology: Incremental Commerce (unlocks Import/Export chests)
  {
    type = "technology",
    name = "ii-incremental-commerce",
    icon = "__base__/graphics/technology/automation-science-pack.png",
    icon_size = 256,
    effects = {
      {type = "unlock-recipe", recipe = "ii-import-chest"},
      {type = "unlock-recipe", recipe = "ii-export-chest"}
    },
    prerequisites = {"ii-planet-discovery"},
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "z-a-a"
  },
  
  -- Data Terminal technology
  {
    type = "technology",
    name = "ii-data-terminal",
    icon = "__base__/graphics/technology/robotics.png",
    icon_size = 256,
    effects = {
      {type = "unlock-recipe", recipe = "ii-data-terminal"},
      {type = "unlock-recipe", recipe = "ii-data-matrix"}
    },
    prerequisites = {"ii-incremental-commerce", "advanced-circuit"},
    unit = {
      count = 200,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 45
    },
    order = "z-a-b"
  },
  
  -- Commerce Science technology
  {
    type = "technology",
    name = "ii-commerce-science",
    icon = "__base__/graphics/technology/research-speed.png",
    icon_size = 256,
    effects = {
      {type = "unlock-recipe", recipe = "ii-commerce-science-pack"}
    },
    prerequisites = {"ii-data-terminal", "production-science-pack"},
    unit = {
      count = 500,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    order = "z-a-c"
  },
  
  -- Order Tier 2 unlock
  {
    type = "technology",
    name = "ii-advanced-orders",
    icon = "__base__/graphics/technology/logistics-2.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"ii-incremental-commerce"},
    unit = {
      count = 150,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "z-b-a"
  },
  
  -- Order Tier 3 unlock
  {
    type = "technology",
    name = "ii-complex-orders",
    icon = "__base__/graphics/technology/logistics-3.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"ii-advanced-orders", "chemical-science-pack"},
    unit = {
      count = 300,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 45
    },
    order = "z-b-b"
  },
  
  -- Order Tier 4 unlock
  {
    type = "technology",
    name = "ii-industrial-orders",
    icon = "__base__/graphics/technology/automation-3.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"ii-complex-orders", "production-science-pack"},
    unit = {
      count = 500,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    order = "z-b-c"
  },
  
  -- Order Tier 5 unlock
  {
    type = "technology",
    name = "ii-mega-orders",
    icon = "__base__/graphics/technology/rocket-silo.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"ii-industrial-orders", "utility-science-pack"},
    unit = {
      count = 1000,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    order = "z-b-d"
  },
  
  -- Infinite technologies using Commerce Science
  
  -- Crafting Speed Bonus (infinite) - affects hand-crafting speed
  {
    type = "technology",
    name = "ii-crafting-speed-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/automation-3.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/automation-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "character-crafting-speed",
        modifier = 0.05
      }
    },
    prerequisites = {"ii-commerce-science"},
    unit = {
      count_formula = "100 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-a"
  },
  
  -- Mining Productivity Bonus (infinite)
  {
    type = "technology",
    name = "ii-mining-productivity-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/automation-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.02
      }
    },
    prerequisites = {"ii-commerce-science"},
    unit = {
      count_formula = "150 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-b"
  },
  
  -- Lab Speed Bonus (infinite)
  {
    type = "technology",
    name = "ii-lab-speed-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/research-speed.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/automation-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "laboratory-speed",
        modifier = 0.05
      }
    },
    prerequisites = {"ii-commerce-science"},
    unit = {
      count_formula = "100 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-c"
  },
  
  -- Robot Cargo Size Bonus (infinite)
  {
    type = "technology",
    name = "ii-robot-cargo-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/worker-robots-speed.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/automation-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "worker-robot-storage",
        modifier = 1
      }
    },
    prerequisites = {"ii-commerce-science", "worker-robots-storage-3"},
    unit = {
      count_formula = "200 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-d"
  },
  
  -- Robot Speed Bonus (infinite)
  {
    type = "technology",
    name = "ii-robot-speed-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/worker-robots-speed.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/logistic-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "worker-robot-speed",
        modifier = 0.05
      }
    },
    prerequisites = {"ii-commerce-science", "worker-robots-speed-6"},
    unit = {
      count_formula = "200 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-e"
  },
  
  -- Inserter Capacity Bonus (infinite)
  {
    type = "technology",
    name = "ii-inserter-capacity-bonus",
    icons = {
      {
        icon = "__base__/graphics/technology/inserter-capacity.png",
        icon_size = 256
      },
      {
        icon = "__base__/graphics/icons/automation-science-pack.png",
        icon_size = 64,
        scale = 1,
        shift = {50, 50}
      }
    },
    effects = {
      {
        type = "inserter-stack-size-bonus",
        modifier = 1
      }
    },
    prerequisites = {"ii-commerce-science", "inserter-capacity-bonus-7"},
    unit = {
      count_formula = "150 * (L^1.5)",
      ingredients = {
        {"ii-commerce-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "z-c-f"
  }
})
