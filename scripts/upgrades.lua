-- Incremental Industrialist - Upgrade System
-- Defines available upgrades and their application

local Upgrades = {}

-- Upgrade definitions
Upgrades.DEFINITIONS = {
  -- Import upgrades
  import_rate = {
    name = "import_rate",
    category = "imports",
    base_cost = 500,
    cost_scaling = 1.5,
    max_level = 20,
    effect_per_level = 0.1, -- +10% import rate per level
    description = "ii-upgrade.import-rate-description"
  },
  
  -- Order upgrades
  order_slots = {
    name = "order_slots",
    category = "orders",
    base_cost = 1000,
    cost_scaling = 2.0,
    max_level = 7,
    effect_per_level = 1, -- +1 order slot per level
    description = "ii-upgrade.order-slots-description"
  },
  
  order_reward_bonus = {
    name = "order_reward_bonus",
    category = "orders",
    base_cost = 750,
    cost_scaling = 1.6,
    max_level = 25,
    effect_per_level = 0.05, -- +5% reward bonus per level
    description = "ii-upgrade.order-reward-bonus-description"
  },
  
  -- Factory bonuses (apply to force)
  factory_assembler_speed = {
    name = "factory_assembler_speed",
    category = "factory",
    base_cost = 2000,
    cost_scaling = 1.8,
    max_level = 50,
    effect_per_level = 0.02, -- +2% assembler speed per level
    description = "ii-upgrade.assembler-speed-description"
  },
  
  factory_mining_speed = {
    name = "factory_mining_speed",
    category = "factory",
    base_cost = 2000,
    cost_scaling = 1.8,
    max_level = 50,
    effect_per_level = 0.02, -- +2% mining speed per level
    description = "ii-upgrade.mining-speed-description"
  },
  
  factory_research_speed = {
    name = "factory_research_speed",
    category = "factory",
    base_cost = 3000,
    cost_scaling = 1.9,
    max_level = 50,
    effect_per_level = 0.02, -- +2% research speed per level
    description = "ii-upgrade.research-speed-description"
  },
  
  -- Exchange Data upgrades
  data_conversion_efficiency = {
    name = "data_conversion_efficiency",
    category = "exchange",
    base_cost = 1500,
    cost_scaling = 1.7,
    max_level = 30,
    effect_per_level = 0.05, -- -5% conversion cost per level
    description = "ii-upgrade.data-conversion-description"
  }
}

-- Import material unlock costs
Upgrades.IMPORT_UNLOCK_COSTS = {
  -- Tier 2
  ["iron-plate"] = 500,
  ["copper-plate"] = 500,
  ["steel-plate"] = 1000,
  ["stone-brick"] = 300,
  
  -- Tier 3
  ["iron-gear-wheel"] = 800,
  ["copper-cable"] = 400,
  ["electronic-circuit"] = 1500,
  ["pipe"] = 600,
  
  -- Tier 4
  ["advanced-circuit"] = 5000,
  ["plastic-bar"] = 2000,
  ["sulfur"] = 1500,
  ["battery"] = 3000,
  ["engine-unit"] = 4000,
  
  -- Tier 5
  ["processing-unit"] = 15000,
  ["electric-engine-unit"] = 8000,
  ["low-density-structure"] = 10000,
  ["rocket-fuel"] = 6000
}

-- Calculate upgrade cost
function Upgrades.get_cost(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return nil end
  
  local current_level = global.ii_data.upgrade_levels[upgrade_name] or 0
  if current_level >= def.max_level then return nil end
  
  return math.floor(def.base_cost * (def.cost_scaling ^ current_level))
end

-- Get current upgrade level
function Upgrades.get_level(upgrade_name)
  return global.ii_data.upgrade_levels[upgrade_name] or 0
end

-- Get upgrade effect value
function Upgrades.get_effect(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return 0 end
  
  local level = global.ii_data.upgrade_levels[upgrade_name] or 0
  return level * def.effect_per_level
end

-- Purchase an upgrade
function Upgrades.purchase(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return false, "Invalid upgrade" end
  
  local current_level = global.ii_data.upgrade_levels[upgrade_name] or 0
  if current_level >= def.max_level then
    return false, "Already at max level"
  end
  
  local cost = Upgrades.get_cost(upgrade_name)
  if not cost then return false, "Cannot calculate cost" end
  
  local TradeHub = require("scripts.trade-hub")
  if not TradeHub.spend_credits(cost) then
    return false, "Insufficient credits"
  end
  
  -- Apply upgrade
  global.ii_data.upgrade_levels[upgrade_name] = current_level + 1
  Upgrades.apply_upgrade(upgrade_name)
  
  return true
end

-- Apply upgrade effects
function Upgrades.apply_upgrade(upgrade_name)
  local def = Upgrades.DEFINITIONS[upgrade_name]
  if not def then return end
  
  local level = global.ii_data.upgrade_levels[upgrade_name] or 0
  local effect = level * def.effect_per_level
  
  if upgrade_name == "import_rate" then
    global.ii_data.upgrades.import_rate = 1.0 + effect
    
  elseif upgrade_name == "order_slots" then
    global.ii_data.upgrades.order_slots = 3 + level
    
  elseif upgrade_name == "order_reward_bonus" then
    global.ii_data.upgrades.order_reward_bonus = 1.0 + effect
    
  elseif upgrade_name == "factory_assembler_speed" then
    -- Apply to all forces
    for _, force in pairs(game.forces) do
      if force.name ~= "enemy" and force.name ~= "neutral" then
        -- Note: In Factorio 2.0, this might need adjustment
        -- This is a placeholder - actual implementation depends on API
        force.manual_crafting_speed_modifier = effect
      end
    end
    global.ii_data.upgrades.factory.assembler_speed = effect
    
  elseif upgrade_name == "factory_mining_speed" then
    for _, force in pairs(game.forces) do
      if force.name ~= "enemy" and force.name ~= "neutral" then
        force.manual_mining_speed_modifier = effect
      end
    end
    global.ii_data.upgrades.factory.mining_speed = effect
    
  elseif upgrade_name == "factory_research_speed" then
    for _, force in pairs(game.forces) do
      if force.name ~= "enemy" and force.name ~= "neutral" then
        force.laboratory_speed_modifier = effect
      end
    end
    global.ii_data.upgrades.factory.research_speed = effect
    
  elseif upgrade_name == "data_conversion_efficiency" then
    global.ii_data.upgrades.data_conversion_efficiency = effect
  end
end

-- Apply all upgrades (called on game load)
function Upgrades.apply_all()
  for upgrade_name, _ in pairs(Upgrades.DEFINITIONS) do
    if global.ii_data.upgrade_levels[upgrade_name] then
      Upgrades.apply_upgrade(upgrade_name)
    end
  end
end

-- Purchase import material unlock
function Upgrades.unlock_import(material_name)
  local cost = Upgrades.IMPORT_UNLOCK_COSTS[material_name]
  if not cost then return false, "Invalid material or already available" end
  
  local TradeHub = require("scripts.trade-hub")
  if TradeHub.is_import_unlocked(material_name) then
    return false, "Already unlocked"
  end
  
  if not TradeHub.spend_credits(cost) then
    return false, "Insufficient credits"
  end
  
  TradeHub.unlock_import(material_name)
  return true
end

-- Handle research completion
function Upgrades.on_research_finished(event)
  local research = event.research
  local name = research.name
  local Orders = require("scripts.orders")
  local TradeHub = require("scripts.trade-hub")
  
  if name == "ii-advanced-orders" then
    Orders.unlock_tier(2)
    -- Unlock tier 2 imports
    for material, data in pairs(TradeHub.IMPORT_MATERIALS) do
      if data.tier == 2 then
        for _, prereq in ipairs(data.prerequisites) do
          if prereq == "ii-advanced-orders" then
            TradeHub.unlock_import(material)
          end
        end
      end
    end
    
  elseif name == "ii-complex-orders" then
    Orders.unlock_tier(3)
    
  elseif name == "ii-industrial-orders" then
    Orders.unlock_tier(4)
    
  elseif name == "ii-mega-orders" then
    Orders.unlock_tier(5)
  end
end

-- Get all upgrade definitions
function Upgrades.get_definitions()
  return Upgrades.DEFINITIONS
end

-- Get upgrades by category
function Upgrades.get_by_category(category)
  local result = {}
  for name, def in pairs(Upgrades.DEFINITIONS) do
    if def.category == category then
      result[name] = def
    end
  end
  return result
end

return Upgrades
