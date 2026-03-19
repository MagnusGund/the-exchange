-- The Exchange - GUI System
-- Main interface for managing orders, upgrades, imports, and statistics

local GUI = {}

-- GUI element names
GUI.NAMES = {
  toggle_button = "ii_toggle_button",
  main_frame = "ii_main_frame",
  tabbed_pane = "ii_tabbed_pane",
  credits_label = "ii_credits_label",
  orders_tab = "ii_orders_tab",
  upgrades_tab = "ii_upgrades_tab",
  imports_tab = "ii_imports_tab",
  exchange_tab = "ii_exchange_tab",
  statistics_tab = "ii_statistics_tab"
}

-- Format large numbers with K/M/B suffixes
local function format_number(num)
  if num >= 1000000000 then
    return string.format("%.2fB", num / 1000000000)
  elseif num >= 1000000 then
    return string.format("%.2fM", num / 1000000)
  elseif num >= 1000 then
    return string.format("%.2fK", num / 1000)
  else
    return tostring(math.floor(num))
  end
end

-- Initialize GUI for a player
function GUI.init_player(player)
  GUI.create_toggle_button(player)
end

-- Create the toggle button in the top-left
function GUI.create_toggle_button(player)
  if player.gui.top[GUI.NAMES.toggle_button] then
    player.gui.top[GUI.NAMES.toggle_button].destroy()
  end
  
  player.gui.top.add{
    type = "sprite-button",
    name = GUI.NAMES.toggle_button,
    sprite = "item/ii-exchange-data",
    tooltip = {"ii-gui.toggle-tooltip"},
    style = "slot_button"
  }
end

-- Toggle the main GUI
function GUI.toggle(player)
  local main_frame = player.gui.screen[GUI.NAMES.main_frame]
  
  if main_frame then
    main_frame.destroy()
  else
    GUI.create_main_frame(player)
  end
end

-- Create the main GUI frame
function GUI.create_main_frame(player)
  if player.gui.screen[GUI.NAMES.main_frame] then
    player.gui.screen[GUI.NAMES.main_frame].destroy()
  end
  
  local main_frame = player.gui.screen.add{
    type = "frame",
    name = GUI.NAMES.main_frame,
    direction = "vertical",
    caption = {"ii-gui.title"}
  }
  main_frame.auto_center = true
  
  -- Header with credits display
  local header_flow = main_frame.add{
    type = "flow",
    direction = "horizontal"
  }
  header_flow.style.horizontal_spacing = 16
  header_flow.style.bottom_margin = 8
  
  header_flow.add{
    type = "label",
    caption = {"ii-gui.credits-label"}
  }
  
  local credits_label = header_flow.add{
    type = "label",
    name = GUI.NAMES.credits_label,
    caption = format_number(storage.ii_data.credits)
  }
  credits_label.style.font = "default-bold"
  credits_label.style.font_color = {r = 1, g = 0.85, b = 0.1}
  
  -- Add close button
  local titlebar_flow = main_frame.add{
    type = "flow",
    direction = "horizontal"
  }
  titlebar_flow.style.horizontally_stretchable = true
  titlebar_flow.add{type = "empty-widget"}.style.horizontally_stretchable = true
  titlebar_flow.add{
    type = "sprite-button",
    name = "ii_close_button",
    sprite = "utility/close",
    style = "close_button",
    tooltip = {"gui.close"}
  }
  
  -- Tabbed pane
  local tabbed_pane = main_frame.add{
    type = "tabbed-pane",
    name = GUI.NAMES.tabbed_pane
  }
  tabbed_pane.style.minimal_width = 600
  tabbed_pane.style.minimal_height = 400
  
  -- Orders tab
  local orders_tab = tabbed_pane.add{type = "tab", caption = {"ii-gui.orders-tab"}}
  local orders_content = tabbed_pane.add{type = "scroll-pane", name = GUI.NAMES.orders_tab}
  orders_content.style.maximal_height = 350
  tabbed_pane.add_tab(orders_tab, orders_content)
  GUI.populate_orders_tab(orders_content)
  
  -- Upgrades tab
  local upgrades_tab = tabbed_pane.add{type = "tab", caption = {"ii-gui.upgrades-tab"}}
  local upgrades_content = tabbed_pane.add{type = "scroll-pane", name = GUI.NAMES.upgrades_tab}
  upgrades_content.style.maximal_height = 350
  tabbed_pane.add_tab(upgrades_tab, upgrades_content)
  GUI.populate_upgrades_tab(upgrades_content)
  
  -- Imports tab
  local imports_tab = tabbed_pane.add{type = "tab", caption = {"ii-gui.imports-tab"}}
  local imports_content = tabbed_pane.add{type = "scroll-pane", name = GUI.NAMES.imports_tab}
  imports_content.style.maximal_height = 350
  tabbed_pane.add_tab(imports_tab, imports_content)
  GUI.populate_imports_tab(imports_content)
  
  -- Exchange Data tab
  local exchange_tab = tabbed_pane.add{type = "tab", caption = {"ii-gui.exchange-tab"}}
  local exchange_content = tabbed_pane.add{type = "scroll-pane", name = GUI.NAMES.exchange_tab}
  exchange_content.style.maximal_height = 350
  tabbed_pane.add_tab(exchange_tab, exchange_content)
  GUI.populate_exchange_tab(exchange_content)
  
  -- Statistics tab
  local stats_tab = tabbed_pane.add{type = "tab", caption = {"ii-gui.statistics-tab"}}
  local stats_content = tabbed_pane.add{type = "scroll-pane", name = GUI.NAMES.statistics_tab}
  stats_content.style.maximal_height = 350
  tabbed_pane.add_tab(stats_tab, stats_content)
  GUI.populate_statistics_tab(stats_content)
  
  player.opened = main_frame
end

-- Populate the Orders tab
function GUI.populate_orders_tab(container)
  container.clear()
  
  local Orders = require("scripts.orders")
  
  -- Active orders section
  container.add{type = "label", caption = {"ii-gui.active-orders"}, style = "heading_2_label"}
  
  local active_orders = Orders.get_active_orders()
  local active_count = 0
  
  for order_id, order in pairs(active_orders) do
    active_count = active_count + 1
    local order_flow = container.add{type = "flow", direction = "horizontal"}
    order_flow.style.vertical_align = "center"
    order_flow.style.horizontal_spacing = 8
    
    -- Item sprite
    order_flow.add{type = "sprite", sprite = "item/" .. order.item}
    
    -- Order info
    local info_flow = order_flow.add{type = "flow", direction = "vertical"}
    info_flow.add{
      type = "label",
      caption = {"ii-gui.order-info", prototypes.item[order.item].localised_name, order.amount}
    }
    
    -- Progress bar
    local progress = order.delivered / order.amount
    local progress_bar = info_flow.add{
      type = "progressbar",
      value = progress
    }
    progress_bar.style.width = 200
    
    -- Progress text
    info_flow.add{
      type = "label",
      caption = string.format("%d / %d (%.1f%%)", order.delivered, order.amount, progress * 100)
    }
    
    -- Reward
    order_flow.add{
      type = "label",
      caption = {"ii-gui.order-reward", format_number(order.reward)}
    }
    
    -- Cancel button
    order_flow.add{
      type = "button",
      name = "ii_cancel_order_" .. order_id,
      caption = {"ii-gui.cancel"},
      style = "red_button"
    }
  end
  
  if active_count == 0 then
    container.add{type = "label", caption = {"ii-gui.no-active-orders"}}
  end
  
  -- Separator
  container.add{type = "line"}.style.top_margin = 8
  
  -- New orders section
  container.add{type = "label", caption = {"ii-gui.available-orders"}, style = "heading_2_label"}
  
  local max_orders = storage.ii_data.upgrades.order_slots or 3
  if active_count < max_orders then
    -- Generate some order options
    for i = 1, 3 do
      local order = Orders.generate_order(nil, i)
      if order then
        local order_flow = container.add{type = "flow", direction = "horizontal"}
        order_flow.style.vertical_align = "center"
        order_flow.style.horizontal_spacing = 8
        
        order_flow.add{type = "sprite", sprite = "item/" .. order.item}
        
        local item_name = prototypes.item[order.item]
        if item_name then
          order_flow.add{
            type = "label",
            caption = {"ii-gui.new-order-info", item_name.localised_name, order.amount, 
              {"ii-gui.size-" .. order.size_tier}}
          }
        end
        
        order_flow.add{
          type = "label",
          caption = {"ii-gui.order-reward", format_number(order.reward)}
        }
        
        order_flow.add{
          type = "button",
          name = "ii_accept_order_" .. i .. "_" .. order.item .. "_" .. order.amount .. "_" .. order.reward .. "_" .. order.tier .. "_" .. order.size_tier,
          caption = {"ii-gui.accept"},
          style = "green_button"
        }
      end
    end
  else
    container.add{type = "label", caption = {"ii-gui.max-orders-reached"}}
  end
end

-- Populate the Upgrades tab
function GUI.populate_upgrades_tab(container)
  container.clear()
  
  local Upgrades = require("scripts.upgrades")
  
  -- Group by category
  local categories = {"imports", "orders", "exchange"}
  local category_names = {
    imports = {"ii-gui.category-imports"},
    orders = {"ii-gui.category-orders"},
    exchange = {"ii-gui.category-exchange"}
  }
  
  for _, category in ipairs(categories) do
    container.add{type = "label", caption = category_names[category], style = "heading_2_label"}
    
    local upgrades = Upgrades.get_by_category(category)
    for name, def in pairs(upgrades) do
      local level = Upgrades.get_level(name)
      local cost = Upgrades.get_cost(name)
      local effect = Upgrades.get_effect(name)
      
      local upgrade_flow = container.add{type = "flow", direction = "horizontal"}
      upgrade_flow.style.vertical_align = "center"
      upgrade_flow.style.horizontal_spacing = 8
      
      upgrade_flow.add{
        type = "label",
        caption = {"ii-upgrade." .. name}
      }
      
      upgrade_flow.add{
        type = "label",
        caption = string.format("Level %d/%d", level, def.max_level)
      }
      
      if effect > 0 then
        upgrade_flow.add{
          type = "label",
          caption = string.format("(+%.0f%%)", effect * 100)
        }
      end
      
      if cost then
        upgrade_flow.add{
          type = "button",
          name = "ii_buy_upgrade_" .. name,
          caption = {"ii-gui.buy-for", format_number(cost)},
          enabled = storage.ii_data.credits >= cost
        }
      else
        upgrade_flow.add{
          type = "label",
          caption = {"ii-gui.max-level"}
        }
      end
    end
    
    container.add{type = "line"}.style.top_margin = 4
  end
end

-- Populate the Imports tab
function GUI.populate_imports_tab(container)
  container.clear()
  
  local TradeHub = require("scripts.trade-hub")
  local Upgrades = require("scripts.upgrades")
  
  -- Unlocked imports
  container.add{type = "label", caption = {"ii-gui.unlocked-imports"}, style = "heading_2_label"}
  
  local unlocked = TradeHub.get_unlocked_imports()
  for _, material in ipairs(unlocked) do
    local mat_flow = container.add{type = "flow", direction = "horizontal"}
    mat_flow.style.vertical_align = "center"
    mat_flow.add{type = "sprite", sprite = "item/" .. material}
    
    local item = prototypes.item[material]
    if item then
      mat_flow.add{type = "label", caption = item.localised_name}
    end
  end
  
  container.add{type = "line"}.style.top_margin = 8
  
  -- Available to unlock
  container.add{type = "label", caption = {"ii-gui.available-imports"}, style = "heading_2_label"}
  
  for material, cost in pairs(Upgrades.IMPORT_UNLOCK_COSTS) do
    if not TradeHub.is_import_unlocked(material) then
      local mat_flow = container.add{type = "flow", direction = "horizontal"}
      mat_flow.style.vertical_align = "center"
      mat_flow.style.horizontal_spacing = 8
      
      mat_flow.add{type = "sprite", sprite = "item/" .. material}
      
      local item = prototypes.item[material]
      if item then
        mat_flow.add{type = "label", caption = item.localised_name}
      end
      
      mat_flow.add{
        type = "button",
        name = "ii_unlock_import_" .. material,
        caption = {"ii-gui.unlock-for", format_number(cost)},
        enabled = storage.ii_data.credits >= cost
      }
    end
  end
  
  container.add{type = "line"}.style.top_margin = 8
  
  -- Import chests info
  container.add{type = "label", caption = {"ii-gui.import-chests"}, style = "heading_2_label"}
  
  local chests = TradeHub.get_all_import_chests()
  local chest_count = 0
  for unit_number, chest_data in pairs(chests) do
    chest_count = chest_count + 1
    local chest_flow = container.add{type = "flow", direction = "horizontal"}
    chest_flow.style.horizontal_spacing = 8
    
    chest_flow.add{type = "label", caption = "Chest #" .. unit_number}
    
    if chest_data.material then
      chest_flow.add{type = "sprite", sprite = "item/" .. chest_data.material}
      local item = prototypes.item[chest_data.material]
      if item then
        chest_flow.add{type = "label", caption = item.localised_name}
      end
    else
      chest_flow.add{type = "label", caption = {"ii-gui.no-material-set"}}
    end
    
    -- Dropdown to change material
    local dropdown_items = {}
    local selected_index = 1
    for i, mat in ipairs(unlocked) do
      local item = prototypes.item[mat]
      if item then
        table.insert(dropdown_items, item.localised_name)
        if mat == chest_data.material then
          selected_index = i
        end
      end
    end
    
    if #dropdown_items > 0 then
      chest_flow.add{
        type = "drop-down",
        name = "ii_chest_material_" .. unit_number,
        items = dropdown_items,
        selected_index = selected_index
      }
    end
  end
  
  if chest_count == 0 then
    container.add{type = "label", caption = {"ii-gui.no-import-chests"}}
  end
end

-- Populate the Exchange Data tab
function GUI.populate_exchange_tab(container)
  container.clear()
  
  local TradeHub = require("scripts.trade-hub")
  
  container.add{type = "label", caption = {"ii-gui.exchange-title"}, style = "heading_2_label"}
  
  -- Current conversion cost
  local cost = TradeHub.get_conversion_cost()
  container.add{
    type = "label",
    caption = {"ii-gui.conversion-cost", format_number(cost)}
  }
  
  -- Total conversions
  container.add{
    type = "label",
    caption = {"ii-gui.total-conversions", storage.ii_data.data_terminal_conversions or 0}
  }
  
  container.add{type = "line"}.style.top_margin = 8
  
  -- Manual conversion (if player wants to convert without terminal)
  container.add{type = "label", caption = {"ii-gui.manual-conversion"}, style = "heading_2_label"}
  
  local convert_flow = container.add{type = "flow", direction = "horizontal"}
  convert_flow.style.horizontal_spacing = 8
  
  convert_flow.add{
    type = "button",
    name = "ii_convert_1",
    caption = {"ii-gui.convert-amount", 1},
    enabled = storage.ii_data.credits >= cost
  }
  
  convert_flow.add{
    type = "button",
    name = "ii_convert_10",
    caption = {"ii-gui.convert-amount", 10},
    enabled = storage.ii_data.credits >= cost * 10
  }
  
  convert_flow.add{
    type = "button",
    name = "ii_convert_100",
    caption = {"ii-gui.convert-amount", 100},
    enabled = storage.ii_data.credits >= cost * 100
  }
  
  container.add{type = "line"}.style.top_margin = 8
  
  -- Data terminals info
  container.add{type = "label", caption = {"ii-gui.data-terminals"}, style = "heading_2_label"}
  
  local terminals = storage.ii_data.data_terminals or {}
  local terminal_count = 0
  for _ in pairs(terminals) do
    terminal_count = terminal_count + 1
  end
  
  container.add{
    type = "label",
    caption = {"ii-gui.terminal-count", terminal_count}
  }
end

-- Populate the Statistics tab
function GUI.populate_statistics_tab(container)
  container.clear()
  
  local stats = storage.ii_data.statistics
  
  container.add{type = "label", caption = {"ii-gui.statistics-title"}, style = "heading_2_label"}
  
  -- Credits
  container.add{
    type = "label",
    caption = {"ii-gui.stat-credits", format_number(storage.ii_data.credits)}
  }
  container.add{
    type = "label",
    caption = {"ii-gui.stat-total-earned", format_number(stats.total_credits_earned or 0)}
  }
  
  container.add{type = "line"}.style.top_margin = 4
  
  -- Orders
  container.add{
    type = "label",
    caption = {"ii-gui.stat-orders-completed", stats.total_orders_completed or 0}
  }
  
  local active_count = 0
  for _ in pairs(storage.ii_data.active_orders) do
    active_count = active_count + 1
  end
  container.add{
    type = "label",
    caption = {"ii-gui.stat-active-orders", active_count}
  }
  
  container.add{type = "line"}.style.top_margin = 4
  
  -- Items
  container.add{
    type = "label",
    caption = {"ii-gui.stat-items-imported", format_number(stats.total_items_imported or 0)}
  }
  container.add{
    type = "label",
    caption = {"ii-gui.stat-items-exported", format_number(stats.total_items_exported or 0)}
  }
  
  container.add{type = "line"}.style.top_margin = 4
  
  -- Exchange Data
  container.add{
    type = "label",
    caption = {"ii-gui.stat-exchange-data", format_number(stats.total_exchange_data_created or 0)}
  }
  
  -- Order tier progress
  container.add{type = "line"}.style.top_margin = 4
  container.add{type = "label", caption = {"ii-gui.unlocked-tiers"}, style = "heading_2_label"}
  
  local tiers = storage.ii_data.unlocked_order_tiers or {1}
  local tier_names = {"Basic", "Advanced", "Complex", "Industrial", "Mega"}
  for _, tier in ipairs(tiers) do
    container.add{
      type = "label",
      caption = "Tier " .. tier .. ": " .. tier_names[tier]
    }
  end
end

-- Update the GUI (refresh data)
function GUI.update(player)
  local main_frame = player.gui.screen[GUI.NAMES.main_frame]
  if not main_frame then return end
  
  -- Update credits display
  local header = main_frame.children[1]
  if header and header[GUI.NAMES.credits_label] then
    header[GUI.NAMES.credits_label].caption = format_number(storage.ii_data.credits)
  end
  
  -- Update current tab content
  local tabbed_pane = main_frame[GUI.NAMES.tabbed_pane]
  if tabbed_pane then
    local selected = tabbed_pane.selected_tab_index
    if selected == 1 then
      GUI.populate_orders_tab(tabbed_pane[GUI.NAMES.orders_tab])
    elseif selected == 2 then
      GUI.populate_upgrades_tab(tabbed_pane[GUI.NAMES.upgrades_tab])
    elseif selected == 3 then
      GUI.populate_imports_tab(tabbed_pane[GUI.NAMES.imports_tab])
    elseif selected == 4 then
      GUI.populate_exchange_tab(tabbed_pane[GUI.NAMES.exchange_tab])
    elseif selected == 5 then
      GUI.populate_statistics_tab(tabbed_pane[GUI.NAMES.statistics_tab])
    end
  end
end

-- Handle GUI click events
function GUI.on_gui_click(event)
  local element = event.element
  if not element or not element.valid then return end
  
  local player = game.players[event.player_index]
  local name = element.name
  
  if name == GUI.NAMES.toggle_button then
    GUI.toggle(player)
    return
  end
  
  if name == "ii_close_button" then
    local main_frame = player.gui.screen[GUI.NAMES.main_frame]
    if main_frame then
      main_frame.destroy()
    end
    return
  end
  
  -- Handle order acceptance
  if string.find(name, "^ii_accept_order_") then
    local parts = {}
    for part in string.gmatch(name, "[^_]+") do
      table.insert(parts, part)
    end
    -- Parse order data from button name
    local Orders = require("scripts.orders")
    local order = Orders.generate_order(tonumber(parts[5]) or nil, tonumber(parts[4]) or nil)
    if order then
      order.item = parts[5]
      order.amount = tonumber(parts[6]) or order.amount
      order.reward = tonumber(parts[7]) or order.reward
      order.tier = tonumber(parts[8]) or order.tier
      order.size_tier = parts[9] or order.size_tier
      
      local success, err = Orders.accept_order(order)
      if success then
        player.print({"ii-messages.order-accepted"})
      else
        player.print({"ii-messages.order-failed", err})
      end
    end
    GUI.update(player)
    return
  end
  
  -- Handle order cancellation
  if string.find(name, "^ii_cancel_order_") then
    local order_id = string.sub(name, 17)
    local Orders = require("scripts.orders")
    Orders.cancel_order(order_id)
    player.print({"ii-messages.order-cancelled"})
    GUI.update(player)
    return
  end
  
  -- Handle upgrade purchase
  if string.find(name, "^ii_buy_upgrade_") then
    local upgrade_name = string.sub(name, 16)
    local Upgrades = require("scripts.upgrades")
    local success, err = Upgrades.purchase(upgrade_name)
    if success then
      player.print({"ii-messages.upgrade-purchased"})
    else
      player.print({"ii-messages.upgrade-failed", err})
    end
    GUI.update(player)
    return
  end
  
  -- Handle import unlock
  if string.find(name, "^ii_unlock_import_") then
    local material = string.sub(name, 18)
    local Upgrades = require("scripts.upgrades")
    local success, err = Upgrades.unlock_import(material)
    if success then
      player.print({"ii-messages.import-unlocked"})
    else
      player.print({"ii-messages.unlock-failed", err})
    end
    GUI.update(player)
    return
  end
  
  -- Handle manual conversion
  if string.find(name, "^ii_convert_") then
    local amount = tonumber(string.sub(name, 12))
    if amount then
      local TradeHub = require("scripts.trade-hub")
      local converted = 0
      for i = 1, amount do
        local cost = TradeHub.get_conversion_cost()
        if storage.ii_data.credits >= cost then
          storage.ii_data.credits = storage.ii_data.credits - cost
          storage.ii_data.data_terminal_conversions = 
            (storage.ii_data.data_terminal_conversions or 0) + 1
          storage.ii_data.statistics.total_exchange_data_created = 
            (storage.ii_data.statistics.total_exchange_data_created or 0) + 1
          converted = converted + 1
          
          -- Give player the exchange data
          player.insert({name = "ii-exchange-data", count = 1})
        else
          break
        end
      end
      if converted > 0 then
        player.print({"ii-messages.converted", converted})
      end
    end
    GUI.update(player)
    return
  end
end

-- Handle dropdown selection
function GUI.on_gui_selection_state_changed(event)
  local element = event.element
  if not element or not element.valid then return end
  
  local name = element.name
  
  -- Handle import chest material selection
  if string.find(name, "^ii_chest_material_") then
    local unit_number = tonumber(string.sub(name, 19))
    if unit_number then
      local TradeHub = require("scripts.trade-hub")
      local unlocked = TradeHub.get_unlocked_imports()
      local selected_material = unlocked[element.selected_index]
      if selected_material then
        TradeHub.set_import_material(unit_number, selected_material)
      end
    end
  end
end

-- Handle GUI closed event
function GUI.on_gui_closed(event)
  local player = game.players[event.player_index]
  if event.element and event.element.name == GUI.NAMES.main_frame then
    event.element.destroy()
  end
end

-- Destroy all GUI elements for a player
function GUI.destroy_player(player)
  if player.gui.top[GUI.NAMES.toggle_button] then
    player.gui.top[GUI.NAMES.toggle_button].destroy()
  end
  if player.gui.screen[GUI.NAMES.main_frame] then
    player.gui.screen[GUI.NAMES.main_frame].destroy()
  end
end

return GUI
