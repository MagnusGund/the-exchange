-- The Exchange - Items
-- Exchange Data, Data Matrix, Commerce Science Pack

-- Item subgroup for The Exchange items
data:extend({
  {
    type = "item-subgroup",
    name = "ii-commerce",
    group = "intermediate-products",
    order = "z-a"
  },
  {
    type = "item-subgroup",
    name = "ii-science",
    group = "science",
    order = "z-a"
  }
})

-- Exchange Data - converted from credits via Data Terminal
data:extend({
  {
    type = "item",
    name = "ii-exchange-data",
    icon = "__base__/graphics/icons/electronic-circuit.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "a[exchange-data]",
    stack_size = 200,
    weight = 1000
  }
})

-- Data Matrix - intermediate product crafted from Exchange Data
data:extend({
  {
    type = "item",
    name = "ii-data-matrix",
    icon = "__base__/graphics/icons/advanced-circuit.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "b[data-matrix]",
    stack_size = 100,
    weight = 2000
  }
})

-- Commerce Science Pack - enables infinite research
data:extend({
  {
    type = "tool",
    name = "ii-commerce-science-pack",
    icon = "__base__/graphics/icons/automation-science-pack.png",
    icon_size = 64,
    subgroup = "ii-science",
    order = "z[commerce-science-pack]",
    stack_size = 200,
    weight = 2500,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value"
  }
})

-- Credit token item (for visual representation in GUI, not placeable)
data:extend({
  {
    type = "item",
    name = "ii-credit-token",
    icon = "__base__/graphics/icons/coin.png",
    icon_size = 64,
    subgroup = "ii-commerce",
    order = "z[credit-token]",
    stack_size = 1000,
    weight = 100,
    flags = {"hidden"}
  }
})
