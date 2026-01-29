-- Incremental Industrialist - Control Stage
-- Runtime game logic and event handlers

local TradeHub = require("scripts.trade-hub")
local Orders = require("scripts.orders")
local Upgrades = require("scripts.upgrades")
local GUI = require("scripts.gui")

-- Initialize mod data on new game
script.on_init(function()
  global.ii_data = global.ii_data or {}
  global.ii_data.credits = 0
  global.ii_data.import_chests = {}
  global.ii_data.export_chests = {}
  global.ii_data.active_orders = {}
  global.ii_data.completed_orders = {}
  global.ii_data.upgrades = {
    -- Import unlocks (tracks which materials are unlocked)
    imports = {
      ["iron-ore"] = true,
      ["copper-ore"] = true,
      ["coal"] = true,
      ["stone"] = true,
    },
    -- Import tier upgrades (ore -> plate -> intermediate)
    import_tiers = {},
    -- Import rate multiplier
    import_rate = 1.0,
    -- Order-related upgrades
    order_slots = 3,
    -- Factory bonuses
    factory = {
      assembler_speed = 0,
      inserter_speed = 0,
      mining_productivity = 0,
      lab_speed = 0,
      robot_cargo_size = 0,
      robot_speed = 0,
    },
  }
  global.ii_data.order_progress = {}  -- Tracks tier progress per product type

  Orders.initialize()
end)

-- Handle mod updates and migrations
script.on_configuration_changed(function(data)
  global.ii_data = global.ii_data or {}

  -- Ensure all data structures exist
  global.ii_data.credits = global.ii_data.credits or 0
  global.ii_data.import_chests = global.ii_data.import_chests or {}
  global.ii_data.export_chests = global.ii_data.export_chests or {}
  global.ii_data.active_orders = global.ii_data.active_orders or {}
  global.ii_data.completed_orders = global.ii_data.completed_orders or {}
  global.ii_data.upgrades = global.ii_data.upgrades or {}
  global.ii_data.order_progress = global.ii_data.order_progress or {}

  -- Re-apply factory bonuses after config change
  Upgrades.apply_all_bonuses()
end)

-- Player created event
script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  if player then
    GUI.create_toggle_button(player)
  end
end)

-- Handle entity built events
script.on_event(defines.events.on_built_entity, function(event)
  TradeHub.on_entity_built(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
  TradeHub.on_entity_built(event)
end)

-- Handle entity removed events
script.on_event(defines.events.on_player_mined_entity, function(event)
  TradeHub.on_entity_removed(event)
end)

script.on_event(defines.events.on_robot_mined_entity, function(event)
  TradeHub.on_entity_removed(event)
end)

script.on_event(defines.events.on_entity_died, function(event)
  TradeHub.on_entity_removed(event)
end)

-- Main tick handler for import spawning and export checking
script.on_nth_tick(30, function(event)  -- Every 0.5 seconds
  TradeHub.process_imports()
  TradeHub.process_exports()
end)

-- GUI events
script.on_event(defines.events.on_gui_click, function(event)
  GUI.on_click(event)
end)

script.on_event(defines.events.on_gui_closed, function(event)
  GUI.on_closed(event)
end)

-- Research completed - check for unlocks
script.on_event(defines.events.on_research_finished, function(event)
  Upgrades.on_research_finished(event)
end)

-- Remote interface for other mods
remote.add_interface("incremental-industrialist", {
  get_credits = function()
    return global.ii_data.credits
  end,
  add_credits = function(amount)
    global.ii_data.credits = global.ii_data.credits + amount
  end,
  get_upgrades = function()
    return global.ii_data.upgrades
  end,
})
