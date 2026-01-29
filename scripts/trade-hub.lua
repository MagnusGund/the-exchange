-- Trade Hub Runtime Logic
-- Handles import chest spawning and export chest validation

local TradeHub = {}

-- Configuration for import materials
TradeHub.IMPORT_MATERIALS = {
  -- Tier 0: Raw ores (available from start)
  {name = "iron-ore", tier = 0, category = "ore"},
  {name = "copper-ore", tier = 0, category = "ore"},
  {name = "coal", tier = 0, category = "ore"},
  {name = "stone", tier = 0, category = "ore"},

  -- Tier 1: Basic processed (requires tech)
  {name = "iron-plate", tier = 1, category = "plate", prerequisite = "iron-ore"},
  {name = "copper-plate", tier = 1, category = "plate", prerequisite = "copper-ore"},
  {name = "stone-brick", tier = 1, category = "plate", prerequisite = "stone"},
  {name = "steel-plate", tier = 1, category = "plate", prerequisite = "iron-plate"},

  -- Tier 2: Basic intermediates (requires prerequisites)
  {name = "copper-cable", tier = 2, category = "intermediate", prerequisite = "copper-plate"},
  {name = "iron-gear-wheel", tier = 2, category = "intermediate", prerequisite = "iron-plate"},
  {name = "iron-stick", tier = 2, category = "intermediate", prerequisite = "iron-plate"},

  -- Tier 3: Advanced intermediates
  {name = "electronic-circuit", tier = 3, category = "circuit", prerequisites = {"iron-plate", "copper-cable"}},
  {name = "advanced-circuit", tier = 4, category = "circuit", prerequisites = {"electronic-circuit", "plastic-bar"}},
  {name = "processing-unit", tier = 5, category = "circuit", prerequisites = {"advanced-circuit", "electronic-circuit"}},
}

-- Base items per tick at 30 tick intervals (0.5 seconds)
local BASE_ITEMS_PER_CYCLE = 1

-- Called when a relevant entity is built
function TradeHub.on_entity_built(event)
  local entity = event.entity or event.created_entity
  if not entity or not entity.valid then return end

  local name = entity.name

  if name == "ii-trade-hub" then
    -- Register the trade hub
    local unit_number = entity.unit_number
    global.ii_data.trade_hubs = global.ii_data.trade_hubs or {}
    global.ii_data.trade_hubs[unit_number] = {
      entity = entity,
      position = entity.position,
      surface = entity.surface.index,
    }

  elseif name == "ii-import-chest" then
    -- Register import chest
    local unit_number = entity.unit_number
    global.ii_data.import_chests[unit_number] = {
      entity = entity,
      position = entity.position,
      surface = entity.surface.index,
      material = nil,  -- Set via GUI
      rate_multiplier = 1.0,
      accumulated = 0,  -- Fractional item accumulator
    }

  elseif name == "ii-export-chest" then
    -- Register export chest
    local unit_number = entity.unit_number
    global.ii_data.export_chests[unit_number] = {
      entity = entity,
      position = entity.position,
      surface = entity.surface.index,
    }
  end
end

-- Called when a relevant entity is removed
function TradeHub.on_entity_removed(event)
  local entity = event.entity
  if not entity or not entity.valid then return end

  local name = entity.name
  local unit_number = entity.unit_number

  if name == "ii-trade-hub" then
    if global.ii_data.trade_hubs then
      global.ii_data.trade_hubs[unit_number] = nil
    end
  elseif name == "ii-import-chest" then
    global.ii_data.import_chests[unit_number] = nil
  elseif name == "ii-export-chest" then
    global.ii_data.export_chests[unit_number] = nil
  end
end

-- Process all import chests - spawn items
function TradeHub.process_imports()
  local upgrades = global.ii_data.upgrades
  local base_rate = BASE_ITEMS_PER_CYCLE * (upgrades.import_rate or 1.0)

  for unit_number, data in pairs(global.ii_data.import_chests) do
    if data.entity and data.entity.valid and data.material then
      local entity = data.entity
      local inventory = entity.get_inventory(defines.inventory.chest)

      if inventory then
        -- Calculate items to spawn this cycle
        local rate = base_rate * (data.rate_multiplier or 1.0)
        data.accumulated = (data.accumulated or 0) + rate

        local items_to_spawn = math.floor(data.accumulated)
        if items_to_spawn > 0 then
          data.accumulated = data.accumulated - items_to_spawn

          -- Try to insert items into chest
          local inserted = inventory.insert({name = data.material, count = items_to_spawn})

          -- If chest is full, try to output to adjacent belt
          if inserted < items_to_spawn then
            TradeHub.output_to_belt(entity, data.material, items_to_spawn - inserted)
          end
        end
      end
    else
      -- Clean up invalid entries
      if not data.entity or not data.entity.valid then
        global.ii_data.import_chests[unit_number] = nil
      end
    end
  end
end

-- Output items directly to adjacent belt
function TradeHub.output_to_belt(entity, item_name, count)
  local position = entity.position
  local surface = entity.surface

  -- Check all 4 adjacent positions for belts
  local offsets = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}

  for _, offset in pairs(offsets) do
    local check_pos = {x = position.x + offset[1], y = position.y + offset[2]}
    local belt = surface.find_entity("transport-belt", check_pos)
          or surface.find_entity("fast-transport-belt", check_pos)
          or surface.find_entity("express-transport-belt", check_pos)
          or surface.find_entity("turbo-transport-belt", check_pos)

    if belt and belt.valid then
      local transport_line = belt.get_transport_line(1)  -- Line 1 is the right side
      if transport_line then
        for i = 1, count do
          if transport_line.insert_at_back({name = item_name}) then
            count = count - 1
            if count <= 0 then return end
          else
            break  -- Belt is full
          end
        end
      end
    end
  end
end

-- Process all export chests - check for order completion
function TradeHub.process_exports()
  local Orders = require("scripts.orders")
  local active_orders = global.ii_data.active_orders

  for unit_number, data in pairs(global.ii_data.export_chests) do
    if data.entity and data.entity.valid then
      local entity = data.entity
      local inventory = entity.get_inventory(defines.inventory.chest)

      if inventory then
        local contents = inventory.get_contents()

        for item_name, item_count in pairs(contents) do
          -- Check if this item matches any active order
          for order_id, order in pairs(active_orders) do
            if order.item == item_name and order.delivered < order.required then
              local needed = order.required - order.delivered
              local to_consume = math.min(item_count, needed)

              if to_consume > 0 then
                inventory.remove({name = item_name, count = to_consume})
                order.delivered = order.delivered + to_consume

                -- Check for order completion
                if order.delivered >= order.required then
                  Orders.complete_order(order_id)
                end
              end
            end
          end
        end
      end
    else
      -- Clean up invalid entries
      if not data.entity or not data.entity.valid then
        global.ii_data.export_chests[unit_number] = nil
      end
    end
  end
end

-- Get available import materials based on unlocks
function TradeHub.get_available_imports()
  local unlocks = global.ii_data.upgrades.imports
  local tier_unlocks = global.ii_data.upgrades.import_tiers
  local available = {}

  for _, material in pairs(TradeHub.IMPORT_MATERIALS) do
    local is_unlocked = false

    -- Check if base material is unlocked
    if unlocks[material.name] then
      is_unlocked = true
    elseif material.tier == 0 then
      -- Tier 0 materials are always available
      is_unlocked = true
    elseif tier_unlocks[material.name] then
      -- Higher tier version unlocked
      is_unlocked = true
    end

    if is_unlocked then
      table.insert(available, material)
    end
  end

  return available
end

-- Set the material for an import chest
function TradeHub.set_import_material(unit_number, material_name)
  local chest_data = global.ii_data.import_chests[unit_number]
  if chest_data then
    chest_data.material = material_name
    return true
  end
  return false
end

return TradeHub
