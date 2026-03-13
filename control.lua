-- The Exchange - Control Stage Entry Point
-- Main runtime logic and event handlers

local TradeHub = require("scripts.trade-hub")
local Orders = require("scripts.orders")
local Upgrades = require("scripts.upgrades")
local GUI = require("scripts.gui")

-- Initialize global data on new game or mod added
local function on_init()
  TradeHub.init_global()
  
  -- Initialize GUI for all existing players
  for _, player in pairs(game.players) do
    GUI.init_player(player)
  end
end

-- Handle configuration changes
local function on_configuration_changed(event)
  TradeHub.init_global()
  Upgrades.apply_all()
  
  -- Reinitialize GUI for all players
  for _, player in pairs(game.players) do
    GUI.destroy_player(player)
    GUI.init_player(player)
  end
end

-- Handle game load
local function on_load()
  -- Nothing special needed on load
end

-- Handle new player creation
local function on_player_created(event)
  local player = game.players[event.player_index]
  GUI.init_player(player)
  
  -- Show welcome message if tips enabled
  if settings.get_player_settings(player)["ii-show-tutorial-tips"].value then
    player.print({"ii-messages.welcome"})
  end
end

-- Handle player removed
local function on_player_removed(event)
  -- Clean up player GUI data if needed
end

-- Handle entity built
local function on_entity_built(event)
  local entity = event.entity or event.created_entity
  if not entity or not entity.valid then return end
  
  local name = entity.name
  
  if name == "ii-import-chest" then
    TradeHub.register_import_chest(entity)
  elseif name == "ii-export-chest" then
    TradeHub.register_export_chest(entity)
  elseif name == "ii-data-terminal" then
    TradeHub.register_data_terminal(entity)
  end
end

-- Handle entity removed
local function on_entity_removed(event)
  local entity = event.entity
  if not entity or not entity.valid then return end
  
  local name = entity.name
  
  if name == "ii-import-chest" or name == "ii-export-chest" or name == "ii-data-terminal" then
    TradeHub.unregister_entity(entity)
  end
end

-- Process imports and exports (on_nth_tick)
local function on_tick_processing(event)
  TradeHub.process_imports()
  TradeHub.process_exports()
  TradeHub.process_data_terminals()
  
  -- Update GUI for all players periodically
  if event.tick % 60 == 0 then
    for _, player in pairs(game.players) do
      if player.gui.screen[GUI.NAMES.main_frame] then
        GUI.update(player)
      end
    end
  end
end

-- Handle research completed
local function on_research_finished(event)
  Upgrades.on_research_finished(event)
end

-- Handle shortcut button
local function on_lua_shortcut(event)
  if event.prototype_name == "ii-toggle-gui" then
    local player = game.players[event.player_index]
    GUI.toggle(player)
  elseif event.prototype_name == "ii-quick-orders" then
    local player = game.players[event.player_index]
    GUI.toggle(player)
    -- Could add logic to auto-switch to orders tab
  end
end

-- Handle custom keybinds
local function on_custom_input(event)
  local player = game.players[event.player_index]
  
  if event.input_name == "ii-toggle-gui-key" then
    GUI.toggle(player)
  elseif event.input_name == "ii-quick-accept-order" then
    -- Quick accept first available order
    local max_orders = global.ii_data.upgrades.order_slots or 3
    local active_count = 0
    for _ in pairs(global.ii_data.active_orders) do
      active_count = active_count + 1
    end
    
    if active_count < max_orders then
      local order = Orders.generate_order()
      if order then
        Orders.accept_order(order)
        player.print({"ii-messages.order-accepted"})
      end
    else
      player.print({"ii-messages.max-orders-reached"})
    end
  end
end

-- Handle GUI events
local function on_gui_click(event)
  GUI.on_gui_click(event)
end

local function on_gui_selection_state_changed(event)
  GUI.on_gui_selection_state_changed(event)
end

local function on_gui_closed(event)
  GUI.on_gui_closed(event)
end

-- Remote interface for console commands
remote.add_interface("the-exchange", {
  add_credits = function(amount)
    TradeHub.add_credits(amount)
  end,
  
  get_credits = function()
    return TradeHub.get_credits()
  end,
  
  get_upgrades = function()
    return global.ii_data.upgrades
  end,
  
  get_statistics = function()
    return global.ii_data.statistics
  end,
  
  unlock_all_imports = function()
    for material, _ in pairs(TradeHub.IMPORT_MATERIALS) do
      TradeHub.unlock_import(material)
    end
  end,
  
  unlock_all_tiers = function()
    for i = 1, 5 do
      Orders.unlock_tier(i)
    end
  end,
  
  set_import_material = function(unit_number, material)
    return TradeHub.set_import_material(unit_number, material)
  end
})

-- Register events
script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
script.on_load(on_load)

script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_player_removed, on_player_removed)

-- Entity events
local entity_filter = {
  {filter = "name", name = "ii-import-chest"},
  {filter = "name", name = "ii-export-chest"},
  {filter = "name", name = "ii-data-terminal"}
}

script.on_event(defines.events.on_built_entity, on_entity_built, entity_filter)
script.on_event(defines.events.on_robot_built_entity, on_entity_built, entity_filter)
script.on_event(defines.events.script_raised_built, on_entity_built, entity_filter)
script.on_event(defines.events.script_raised_revive, on_entity_built, entity_filter)

script.on_event(defines.events.on_player_mined_entity, on_entity_removed, entity_filter)
script.on_event(defines.events.on_robot_mined_entity, on_entity_removed, entity_filter)
script.on_event(defines.events.on_entity_died, on_entity_removed, entity_filter)
script.on_event(defines.events.script_raised_destroy, on_entity_removed, entity_filter)

-- Tick processing
local tick_rate = settings.global["ii-import-tick-rate"] and settings.global["ii-import-tick-rate"].value or 30
script.on_nth_tick(tick_rate, on_tick_processing)

-- Research events
script.on_event(defines.events.on_research_finished, on_research_finished)

-- Shortcut and input events
script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
script.on_event("ii-toggle-gui-key", on_custom_input)
script.on_event("ii-quick-accept-order", on_custom_input)

-- GUI events
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_selection_state_changed)
script.on_event(defines.events.on_gui_closed, on_gui_closed)
