-- The Exchange - Recipes

-- Data Matrix recipe (Exchange Data + electronic circuits)
data:extend({
  {
    type = "recipe",
    name = "ii-data-matrix",
    category = "crafting",
    enabled = false,
    energy_required = 5,
    ingredients = {
      {type = "item", name = "ii-exchange-data", amount = 5},
      {type = "item", name = "electronic-circuit", amount = 2},
      {type = "item", name = "iron-plate", amount = 1}
    },
    results = {
      {type = "item", name = "ii-data-matrix", amount = 1}
    },
    allow_productivity = true
  }
})

-- Commerce Science Pack recipe
data:extend({
  {
    type = "recipe",
    name = "ii-commerce-science-pack",
    category = "crafting",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "ii-data-matrix", amount = 3},
      {type = "item", name = "advanced-circuit", amount = 1},
      {type = "item", name = "copper-cable", amount = 10}
    },
    results = {
      {type = "item", name = "ii-commerce-science-pack", amount = 1}
    },
    allow_productivity = true
  }
})

-- Import Chest recipe
data:extend({
  {
    type = "recipe",
    name = "ii-import-chest",
    category = "crafting",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {type = "item", name = "steel-chest", amount = 1},
      {type = "item", name = "electronic-circuit", amount = 5},
      {type = "item", name = "iron-gear-wheel", amount = 4}
    },
    results = {
      {type = "item", name = "ii-import-chest", amount = 1}
    }
  }
})

-- Export Chest recipe
data:extend({
  {
    type = "recipe",
    name = "ii-export-chest",
    category = "crafting",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {type = "item", name = "steel-chest", amount = 1},
      {type = "item", name = "electronic-circuit", amount = 5},
      {type = "item", name = "iron-gear-wheel", amount = 4}
    },
    results = {
      {type = "item", name = "ii-export-chest", amount = 1}
    }
  }
})

-- Data Terminal recipe
data:extend({
  {
    type = "recipe",
    name = "ii-data-terminal",
    category = "crafting",
    enabled = false,
    energy_required = 5,
    ingredients = {
      {type = "item", name = "steel-plate", amount = 10},
      {type = "item", name = "advanced-circuit", amount = 5},
      {type = "item", name = "copper-cable", amount = 20}
    },
    results = {
      {type = "item", name = "ii-data-terminal", amount = 1}
    }
  }
})
