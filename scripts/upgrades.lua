-- Upgrade System
-- Manages purchasable upgrades and factory bonuses

local Upgrades = {}

-- Upgrade definitions
Upgrades.DEFINITIONS = {
  -- Import rate upgrades
  import_rate = {
    name = "import-rate",
    category = "imports",
    max_level = 50,
    base_cost = 100,
    cost_scaling = 1.5,  -- Each level costs 1.5x more
    effect_per_level = 0.1,  -- +10% per level
    description = "upgrade-import-rate",
  },

  -- Order slot upgrades
  order_slots = {
    name = "order-slots",
    category = "exports",
    max_level = 10,
    base_cost = 500,
    cost_scaling = 2.0,
    effect_per_level = 1,  -- +1 slot per level
    description = "upgrade-order-slots",
  },

  -- Factory bonuses
  assembler_speed = {
    name = "assembler-speed",
    category = "factory",
    max_level = 100,
    base_cost = 200,
    cost_scaling = 1.4,
    effect_per_level = 0.02,  -- +2% per level
    description = "upgrade-assembler-speed",
    force_bonus = "laboratory-speed-modifier",  -- Placeholder, will use custom application
  },

  inserter_speed = {
    name = "inserter-speed",
    category = "factory",
    max_level = 50,
    base_cost = 150,
    cost_scaling = 1.4,
    effect_per_level = 0.02,  -- +2% per level
    description = "upgrade-inserter-speed",
  },

  mining_productivity = {
    name = "mining-productivity",
    category = "factory",
    max_level = 100,
    base_cost = 300,
    cost_scaling = 1.5,
    effect_per_level = 0.01,  -- +1% per level
    description = "upgrade-mining-productivity",
    force_bonus = "mining-drill-productivity-bonus",
  },

  lab_speed = {
    name = "lab-speed",
    category = "factory",
    max_level = 50,
    base_cost = 250,
    cost_scaling = 1.5,
    effect_per_level = 0.02,  -- +2% per level
    description = "upgrade-lab-speed",
    force_bonus = "laboratory-speed-modifier",
  },

  -- Robot bonuses (requires technology)
  robot_cargo_size = {
    name = "robot-cargo-size",
    category = "factory",
    max_level = 20,
    base_cost = 1000,
    cost_scaling = 1.8,
    effect_per_level = 1,  -- +1 cargo per level
    description = "upgrade-robot-cargo",
    force_bonus = "worker-robots-storage-bonus",
    requires_tech = "ii-robot-logistics-bonus",
  },

  robot_speed = {
    name = "robot-speed",
    category = "factory",
    max_level = 50,
    base_cost = 800,
    cost_scaling = 1.6,
    effect_per_level = 0.05,  -- +5% per level
    description = "upgrade-robot-speed",
    force_bonus = "worker-robots-speed-modifier",
    requires_tech = "ii-robot-logistics-bonus",
  },
}

-- Calculate cost for next level of an upgrade
function Upgrades.get_cost(upgrade_name, current_level)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return nil end

  current_level = current_level or 0
  return math.floor(def.base_cost * math.pow(def.cost_scaling, current_level))
end

-- Get current level of an upgrade
function Upgrades.get_level(upgrade_name)
  local levels = global.ii_data.upgrade_levels or {}
  return levels[upgrade_name] or 0
end

-- Purchase an upgrade
function Upgrades.purchase(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return false, "invalid-upgrade" end

  -- Check tech requirement
  if def.requires_tech then
    local force = game.forces["player"]
    if not force.technologies[def.requires_tech] or not force.technologies[def.requires_tech].researched then
      return false, "requires-technology"
    end
  end

  -- Check max level
  local current_level = Upgrades.get_level(upgrade_name)
  if current_level >= def.max_level then
    return false, "max-level"
  end

  -- Check cost
  local cost = Upgrades.get_cost(upgrade_name, current_level)
  if global.ii_data.credits < cost then
    return false, "not-enough-credits"
  end

  -- Purchase
  global.ii_data.credits = global.ii_data.credits - cost
  global.ii_data.upgrade_levels = global.ii_data.upgrade_levels or {}
  global.ii_data.upgrade_levels[upgrade_name] = current_level + 1

  -- Apply the upgrade effect
  Upgrades.apply_upgrade(upgrade_name)

  return true
end

-- Apply a specific upgrade's effect
function Upgrades.apply_upgrade(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return end

  local level = Upgrades.get_level(upgrade_name)
  local effect = level * def.effect_per_level

  -- Handle special upgrades
  if upgrade_name == "import_rate" then
    global.ii_data.upgrades.import_rate = 1.0 + effect

  elseif upgrade_name == "order_slots" then
    global.ii_data.upgrades.order_slots = 3 + level
    -- Generate new orders if we have empty slots
    local Orders = require("scripts.orders")
    local current_orders = table_size(global.ii_data.active_orders)
    local max_orders = global.ii_data.upgrades.order_slots
    for i = current_orders + 1, max_orders do
      Orders.generate_order()
    end

  elseif def.force_bonus then
    -- Apply force bonus
    local force = game.forces["player"]
    if force then
      if def.force_bonus == "mining-drill-productivity-bonus" then
        force.mining_drill_productivity_bonus = effect
      elseif def.force_bonus == "laboratory-speed-modifier" then
        force.laboratory_speed_modifier = effect
      elseif def.force_bonus == "worker-robots-storage-bonus" then
        force.worker_robots_storage_bonus = math.floor(effect)
      elseif def.force_bonus == "worker-robots-speed-modifier" then
        force.worker_robots_speed_modifier = effect
      end
    end
  end

  -- Store in upgrades table for reference
  if def.category == "factory" then
    global.ii_data.upgrades.factory[upgrade_name] = effect
  end
end

-- Apply all upgrades (called on config change)
function Upgrades.apply_all_bonuses()
  for upgrade_name, _ in pairs(Upgrades.DEFINITIONS) do
    if Upgrades.get_level(upgrade_name) > 0 then
      Upgrades.apply_upgrade(upgrade_name)
    end
  end
end

-- Check for technology unlocks
function Upgrades.on_research_finished(event)
  local research = event.research
  if not research then return end

  local name = research.name
  local Orders = require("scripts.orders")

  -- Trade operations unlocks basic trading
  if name == "ii-trade-operations" then
    -- Basic unlocks already handled by recipe unlocks
  end

  -- Advanced imports tech
  if name == "ii-advanced-imports" then
    -- Unlock plate-tier imports
    global.ii_data.upgrades.import_tiers = global.ii_data.upgrades.import_tiers or {}
    -- Players can now purchase plate imports in the upgrade shop
  end

  -- Robot logistics unlocks robot upgrades
  if name == "ii-robot-logistics-bonus" then
    -- Robot upgrades now available in shop (handled by requires_tech check)
  end

  -- Check for research that unlocks new order tiers
  if name == "logistic-science-pack" then
    Orders.unlock_tier(2)
  elseif name == "chemical-science-pack" then
    Orders.unlock_tier(3)
  elseif name == "production-science-pack" or name == "utility-science-pack" then
    Orders.unlock_tier(4)
  elseif name == "space-science-pack" then
    Orders.unlock_tier(5)
  end
end

-- Get all available upgrades (for GUI)
function Upgrades.get_available_upgrades()
  local available = {}
  local force = game.forces["player"]

  for name, def in pairs(Upgrades.DEFINITIONS) do
    local can_show = true

    -- Check tech requirement for visibility
    if def.requires_tech then
      if not force.technologies[def.requires_tech] or not force.technologies[def.requires_tech].researched then
        can_show = false
      end
    end

    if can_show then
      local level = Upgrades.get_level(name)
      local cost = Upgrades.get_cost(name, level)
      local at_max = level >= def.max_level

      table.insert(available, {
        name = name,
        definition = def,
        current_level = level,
        cost = cost,
        at_max = at_max,
        can_afford = global.ii_data.credits >= cost,
      })
    end
  end

  return available
end

return Upgrades
