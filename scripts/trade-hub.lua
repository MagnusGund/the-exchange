-- The Exchange - Trade Hub System
-- Manages import/export chests and material generation

local TradeHub = {}

-- Import material definitions by tier
TradeHub.IMPORT_MATERIALS = {
  -- Tier 1: Basic raw materials
  ["iron-ore"] = {tier = 1, category = "ore", cost_per_item = 1, prerequisites = {}},
  ["copper-ore"] = {tier = 1, category = "ore", cost_per_item = 1, prerequisites = {}},
  ["coal"] = {tier = 1, category = "ore", cost_per_item = 1, prerequisites = {}},
  ["stone"] = {tier = 1, category = "ore", cost_per_item = 0.5, prerequisites = {}},
  ["wood"] = {tier = 1, category = "organic", cost_per_item = 0.5, prerequisites = {}},
  
  -- Tier 2: Processed basics
  ["iron-plate"] = {tier = 2, category = "plate", cost_per_item = 2, prerequisites = {"ii-advanced-orders"}},
  ["copper-plate"] = {tier = 2, category = "plate", cost_per_item = 2, prerequisites = {"ii-advanced-orders"}},
  ["steel-plate"] = {tier = 2, category = "plate", cost_per_item = 5, prerequisites = {"ii-advanced-orders"}},
  ["stone-brick"] = {tier = 2, category = "material", cost_per_item = 2, prerequisites = {"ii-advanced-orders"}},
  
  -- Tier 3: Intermediate products
  ["iron-gear-wheel"] = {tier = 3, category = "intermediate", cost_per_item = 3, prerequisites = {"ii-complex-orders"}},
  ["copper-cable"] = {tier = 3, category = "intermediate", cost_per_item = 1, prerequisites = {"ii-complex-orders"}},
  ["electronic-circuit"] = {tier = 3, category = "circuit", cost_per_item = 5, prerequisites = {"ii-complex-orders"}},
  ["pipe"] = {tier = 3, category = "intermediate", cost_per_item = 2, prerequisites = {"ii-complex-orders"}},
  
  -- Tier 4: Advanced intermediates
  ["advanced-circuit"] = {tier = 4, category = "circuit", cost_per_item = 15, prerequisites = {"ii-industrial-orders"}},
  ["plastic-bar"] = {tier = 4, category = "material", cost_per_item = 5, prerequisites = {"ii-industrial-orders"}},
  ["sulfur"] = {tier = 4, category = "material", cost_per_item = 3, prerequisites = {"ii-industrial-orders"}},
  ["battery"] = {tier = 4, category = "material", cost_per_item = 10, prerequisites = {"ii-industrial-orders"}},
  ["engine-unit"] = {tier = 4, category = "intermediate", cost_per_item = 20, prerequisites = {"ii-industrial-orders"}},
  
  -- Tier 5: High-tech components
  ["processing-unit"] = {tier = 5, category = "circuit", cost_per_item = 50, prerequisites = {"ii-mega-orders"}},
  ["electric-engine-unit"] = {tier = 5, category = "intermediate", cost_per_item = 30, prerequisites = {"ii-mega-orders"}},
  ["low-density-structure"] = {tier = 5, category = "material", cost_per_item = 40, prerequisites = {"ii-mega-orders"}},
  ["rocket-fuel"] = {tier = 5, category = "fuel", cost_per_item = 25, prerequisites = {"ii-mega-orders"}},

  -- Tier 5: Ancient Power resources (for fusion enhancement)
  ["fluoroketone-cold-barrel"] = {tier = 5, category = "fuel", cost_per_item = 35, prerequisites = {"ii-ancient-power"}},
  ["fusion-power-cell"] = {tier = 5, category = "fuel", cost_per_item = 100, prerequisites = {"ii-mega-orders"}}
}

-- Initialize trade hub data structure
function TradeHub.init_global()
  if not global.ii_data then
    global.ii_data = {
      credits = settings.global["ii-starting-credits"].value or 100,
      import_chests = {},
      export_chests = {},
      data_terminals = {},
      active_orders = {},
      completed_orders = {},
      order_progress = {},
      unlocked_order_tiers = {1},
      unlocked_imports = {"iron-ore", "copper-ore", "coal", "stone", "wood"},
      upgrades = {
        imports = {},
        import_tiers = {},
        import_rate = 1.0,
        order_slots = 3,
        factory = {}
      },
      upgrade_levels = {},
      statistics = {
        total_credits_earned = 0,
        total_orders_completed = 0,
        total_items_exported = 0,
        total_items_imported = 0,
        total_exchange_data_created = 0
      },
      data_terminal_conversions = 0
    }
  end
end

-- Register an import chest
function TradeHub.register_import_chest(entity)
  if not entity or not entity.valid then return end
  
  local unit_number = entity.unit_number
  global.ii_data.import_chests[unit_number] = {
    entity = entity,
    material = nil,
    amount_per_tick = settings.global["ii-base-import-amount"].value or 1,
    accumulated = 0
  }
end

-- Register an export chest
function TradeHub.register_export_chest(entity)
  if not entity or not entity.valid then return end
  
  local unit_number = entity.unit_number
  global.ii_data.export_chests[unit_number] = {
    entity = entity,
    target_order = nil
  }
end

-- Register a data terminal
function TradeHub.register_data_terminal(entity)
  if not entity or not entity.valid then return end
  
  local unit_number = entity.unit_number
  global.ii_data.data_terminals[unit_number] = {
    entity = entity,
    active = true
  }
end

-- Unregister an entity
function TradeHub.unregister_entity(entity)
  if not entity then return end
  
  local unit_number = entity.unit_number
  if global.ii_data.import_chests[unit_number] then
    global.ii_data.import_chests[unit_number] = nil
  elseif global.ii_data.export_chests[unit_number] then
    global.ii_data.export_chests[unit_number] = nil
  elseif global.ii_data.data_terminals[unit_number] then
    global.ii_data.data_terminals[unit_number] = nil
  end
end

-- Set material for an import chest
function TradeHub.set_import_material(unit_number, material_name)
  local chest_data = global.ii_data.import_chests[unit_number]
  if not chest_data then return false, "Chest not found" end
  
  -- Validate material is unlocked
  local is_unlocked = false
  for _, unlocked in ipairs(global.ii_data.unlocked_imports) do
    if unlocked == material_name then
      is_unlocked = true
      break
    end
  end
  
  if not is_unlocked then
    return false, "Material not unlocked"
  end
  
  chest_data.material = material_name
  return true
end

-- Process all import chests (called on_nth_tick)
function TradeHub.process_imports()
  local tick_rate = settings.global["ii-import-tick-rate"].value or 30
  local base_amount = settings.global["ii-base-import-amount"].value or 1
  local rate_multiplier = global.ii_data.upgrades.import_rate or 1.0
  
  for unit_number, chest_data in pairs(global.ii_data.import_chests) do
    if chest_data.entity and chest_data.entity.valid and chest_data.material then
      local material = chest_data.material
      local material_info = TradeHub.IMPORT_MATERIALS[material]
      
      if material_info then
        local amount = math.floor(base_amount * rate_multiplier)
        if amount < 1 then amount = 1 end
        
        local inventory = chest_data.entity.get_inventory(defines.inventory.chest)
        if inventory and inventory.can_insert({name = material, count = amount}) then
          local inserted = inventory.insert({name = material, count = amount})
          if inserted > 0 then
            global.ii_data.statistics.total_items_imported = 
              global.ii_data.statistics.total_items_imported + inserted
          end
        end
      end
    else
      -- Clean up invalid chests
      if not chest_data.entity or not chest_data.entity.valid then
        global.ii_data.import_chests[unit_number] = nil
      end
    end
  end
end

-- Process all export chests (called on_nth_tick)
function TradeHub.process_exports()
  local Orders = require("scripts.orders")
  
  for unit_number, chest_data in pairs(global.ii_data.export_chests) do
    if chest_data.entity and chest_data.entity.valid then
      local inventory = chest_data.entity.get_inventory(defines.inventory.chest)
      if inventory then
        local contents = inventory.get_contents()
        
        for _, item_stack in pairs(contents) do
          local item_name = item_stack.name
          local item_count = item_stack.count
          
          -- Find matching active orders
          for order_id, order in pairs(global.ii_data.active_orders) do
            if order.item == item_name and order.delivered < order.amount then
              local needed = order.amount - order.delivered
              local to_take = math.min(needed, item_count)
              
              local removed = inventory.remove({name = item_name, count = to_take})
              if removed > 0 then
                order.delivered = order.delivered + removed
                global.ii_data.statistics.total_items_exported = 
                  global.ii_data.statistics.total_items_exported + removed
                
                -- Check if order is complete
                if order.delivered >= order.amount then
                  Orders.complete_order(order_id)
                end
              end
              break
            end
          end
        end
      end
    else
      -- Clean up invalid chests
      if not chest_data.entity or not chest_data.entity.valid then
        global.ii_data.export_chests[unit_number] = nil
      end
    end
  end
end

-- Process data terminals
function TradeHub.process_data_terminals()
  local base_cost = settings.global["ii-data-terminal-conversion-rate"].value or 100
  local scaling = settings.global["ii-data-terminal-scaling-factor"].value or 1.02

  for unit_number, terminal_data in pairs(global.ii_data.data_terminals) do
    if terminal_data.entity and terminal_data.entity.valid and terminal_data.active then
      local entity = terminal_data.entity
      local output = entity.get_output_inventory()

      if output and output.can_insert({name = "ii-exchange-data", count = 1}) then
        -- Calculate current cost (apply conversion efficiency as multiplicative discount)
        local conversions = global.ii_data.data_terminal_conversions or 0
        local efficiency_level = global.ii_data.upgrade_levels["data_conversion_efficiency"] or 0
        local efficiency_discount = 0.97 ^ efficiency_level -- ~3% cheaper per level, multiplicative
        local cost = math.max(1, math.floor(base_cost * (scaling ^ conversions) * efficiency_discount))
        
        if global.ii_data.credits >= cost then
          global.ii_data.credits = global.ii_data.credits - cost
          output.insert({name = "ii-exchange-data", count = 1})
          global.ii_data.data_terminal_conversions = conversions + 1
          global.ii_data.statistics.total_exchange_data_created = 
            global.ii_data.statistics.total_exchange_data_created + 1
        end
      end
    else
      if not terminal_data.entity or not terminal_data.entity.valid then
        global.ii_data.data_terminals[unit_number] = nil
      end
    end
  end
end

-- Get current conversion cost for data terminal
function TradeHub.get_conversion_cost()
  local base_cost = settings.global["ii-data-terminal-conversion-rate"].value or 100
  local scaling = settings.global["ii-data-terminal-scaling-factor"].value or 1.02
  local conversions = global.ii_data.data_terminal_conversions or 0
  local efficiency_level = global.ii_data.upgrade_levels["data_conversion_efficiency"] or 0
  local efficiency_discount = 0.97 ^ efficiency_level
  return math.max(1, math.floor(base_cost * (scaling ^ conversions) * efficiency_discount))
end

-- Add credits
function TradeHub.add_credits(amount)
  global.ii_data.credits = global.ii_data.credits + amount
  global.ii_data.statistics.total_credits_earned = 
    global.ii_data.statistics.total_credits_earned + amount
end

-- Get credits
function TradeHub.get_credits()
  return global.ii_data.credits
end

-- Spend credits
function TradeHub.spend_credits(amount)
  if global.ii_data.credits >= amount then
    global.ii_data.credits = global.ii_data.credits - amount
    return true
  end
  return false
end

-- Unlock a new import material
function TradeHub.unlock_import(material_name)
  if not TradeHub.IMPORT_MATERIALS[material_name] then
    return false, "Invalid material"
  end
  
  for _, unlocked in ipairs(global.ii_data.unlocked_imports) do
    if unlocked == material_name then
      return false, "Already unlocked"
    end
  end
  
  table.insert(global.ii_data.unlocked_imports, material_name)
  return true
end

-- Check if a material is unlocked
function TradeHub.is_import_unlocked(material_name)
  for _, unlocked in ipairs(global.ii_data.unlocked_imports) do
    if unlocked == material_name then
      return true
    end
  end
  return false
end

-- Get all unlocked imports
function TradeHub.get_unlocked_imports()
  return global.ii_data.unlocked_imports
end

-- Get import chest data by unit number
function TradeHub.get_import_chest(unit_number)
  return global.ii_data.import_chests[unit_number]
end

-- Get all import chests
function TradeHub.get_all_import_chests()
  return global.ii_data.import_chests
end

-- Get all export chests
function TradeHub.get_all_export_chests()
  return global.ii_data.export_chests
end

return TradeHub
