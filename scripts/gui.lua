-- GUI System
-- Handles all user interface elements

local GUI = {}

local MAIN_FRAME_NAME = "ii_main_frame"
local TOGGLE_BUTTON_NAME = "ii_toggle_button"

-- Create the toggle button in the top-left
function GUI.create_toggle_button(player)
  if player.gui.top[TOGGLE_BUTTON_NAME] then
    return  -- Already exists
  end

  player.gui.top.add({
    type = "sprite-button",
    name = TOGGLE_BUTTON_NAME,
    sprite = "item/ii-trade-hub",
    tooltip = {"ii-gui.title"},
    style = "slot_button",
  })
end

-- Toggle the main GUI
function GUI.toggle(player)
  local main_frame = player.gui.screen[MAIN_FRAME_NAME]
  if main_frame then
    main_frame.destroy()
  else
    GUI.create_main_frame(player)
  end
end

-- Create the main GUI frame
function GUI.create_main_frame(player)
  if player.gui.screen[MAIN_FRAME_NAME] then
    player.gui.screen[MAIN_FRAME_NAME].destroy()
  end

  local frame = player.gui.screen.add({
    type = "frame",
    name = MAIN_FRAME_NAME,
    direction = "vertical",
  })
  frame.auto_center = true

  -- Title bar
  local title_flow = frame.add({type = "flow", direction = "horizontal"})
  title_flow.drag_target = frame
  title_flow.add({type = "label", caption = {"ii-gui.title"}, style = "frame_title"})
  title_flow.add({type = "empty-widget", style = "draggable_space_header"}).style.horizontally_stretchable = true

  -- Credits display
  local credits_label = title_flow.add({
    type = "label",
    name = "ii_credits_display",
    caption = {"ii-gui.credits-format", GUI.format_number(global.ii_data.credits)},
    style = "description_label",
  })
  credits_label.style.right_margin = 10

  -- Close button
  title_flow.add({
    type = "sprite-button",
    name = "ii_close_button",
    sprite = "utility/close",
    style = "close_button",
  })

  -- Tab pane
  local tabbed_pane = frame.add({
    type = "tabbed-pane",
    name = "ii_tabbed_pane",
  })

  -- Orders tab
  local orders_tab = tabbed_pane.add({type = "tab", caption = {"ii-gui.orders-tab"}})
  local orders_content = tabbed_pane.add({type = "scroll-pane", name = "ii_orders_content"})
  orders_content.style.maximal_height = 400
  tabbed_pane.add_tab(orders_tab, orders_content)
  GUI.populate_orders_tab(orders_content)

  -- Upgrades tab
  local upgrades_tab = tabbed_pane.add({type = "tab", caption = {"ii-gui.upgrades-tab"}})
  local upgrades_content = tabbed_pane.add({type = "scroll-pane", name = "ii_upgrades_content"})
  upgrades_content.style.maximal_height = 400
  tabbed_pane.add_tab(upgrades_tab, upgrades_content)
  GUI.populate_upgrades_tab(upgrades_content)

  -- Imports tab
  local imports_tab = tabbed_pane.add({type = "tab", caption = {"ii-gui.imports-tab"}})
  local imports_content = tabbed_pane.add({type = "scroll-pane", name = "ii_imports_content"})
  imports_content.style.maximal_height = 400
  tabbed_pane.add_tab(imports_tab, imports_content)
  GUI.populate_imports_tab(imports_content)

  -- Statistics tab
  local stats_tab = tabbed_pane.add({type = "tab", caption = {"ii-gui.statistics-tab"}})
  local stats_content = tabbed_pane.add({type = "scroll-pane", name = "ii_stats_content"})
  stats_content.style.maximal_height = 400
  tabbed_pane.add_tab(stats_tab, stats_content)
  GUI.populate_statistics_tab(stats_content)

  player.opened = frame
end

-- Populate the orders tab
function GUI.populate_orders_tab(container)
  container.clear()

  local Orders = require("scripts.orders")
  local active_orders = Orders.get_active_orders()

  -- Reroll button
  local reroll_cost = Orders.get_reroll_cost()
  local reroll_flow = container.add({type = "flow", direction = "horizontal"})
  reroll_flow.add({
    type = "button",
    name = "ii_reroll_orders",
    caption = {"ii-gui.reroll-orders"},
    tooltip = {"ii-gui.reroll-cost", reroll_cost},
  })
  reroll_flow.add({
    type = "label",
    caption = {"ii-gui.cost", GUI.format_number(reroll_cost)},
  })

  container.add({type = "line"})

  -- Order list
  for order_id, order in pairs(active_orders) do
    local order_frame = container.add({
      type = "frame",
      direction = "vertical",
      style = "inside_shallow_frame",
    })
    order_frame.style.margin = 4
    order_frame.style.padding = 8

    -- Order header
    local header = order_frame.add({type = "flow", direction = "horizontal"})
    header.add({
      type = "sprite",
      sprite = "item/" .. order.item,
    })

    local size_key = "order-" .. order.size_tier
    header.add({
      type = "label",
      caption = {"ii-gui." .. size_key},
      style = "heading_2_label",
    })

    -- Item and progress
    local item_proto = game.item_prototypes[order.item]
    local item_name = item_proto and item_proto.localised_name or order.item

    order_frame.add({
      type = "label",
      caption = item_name,
    })

    -- Progress bar
    local progress = order.delivered / order.required
    local progress_bar = order_frame.add({
      type = "progressbar",
      value = progress,
    })
    progress_bar.style.width = 250

    order_frame.add({
      type = "label",
      caption = {"ii-gui.order-progress", GUI.format_number(order.delivered), GUI.format_number(order.required)},
    })

    -- Reward
    order_frame.add({
      type = "label",
      caption = {"ii-gui.order-reward", GUI.format_number(order.reward)},
      style = "description_label",
    })
  end

  if table_size(active_orders) == 0 then
    container.add({type = "label", caption = "No active orders."})
  end
end

-- Populate the upgrades tab
function GUI.populate_upgrades_tab(container)
  container.clear()

  local Upgrades = require("scripts.upgrades")
  local available = Upgrades.get_available_upgrades()

  -- Group by category
  local categories = {imports = {}, exports = {}, factory = {}}
  for _, upgrade in pairs(available) do
    local cat = upgrade.definition.category
    if categories[cat] then
      table.insert(categories[cat], upgrade)
    end
  end

  -- Display each category
  for cat_name, cat_upgrades in pairs(categories) do
    if #cat_upgrades > 0 then
      container.add({
        type = "label",
        caption = {"ii-gui.upgrade-category-" .. cat_name},
        style = "heading_2_label",
      })

      for _, upgrade in pairs(cat_upgrades) do
        local upgrade_flow = container.add({type = "flow", direction = "horizontal"})
        upgrade_flow.style.vertical_align = "center"

        local effect_display = upgrade.current_level * upgrade.definition.effect_per_level * 100

        if upgrade.at_max then
          upgrade_flow.add({
            type = "button",
            caption = {"ii-gui.max-level"},
            enabled = false,
          })
        else
          upgrade_flow.add({
            type = "button",
            name = "ii_buy_upgrade_" .. upgrade.name,
            caption = GUI.format_number(upgrade.cost),
            enabled = upgrade.can_afford,
            tooltip = {"ii-gui.cost", GUI.format_number(upgrade.cost)},
          })
        end

        local desc_key = upgrade.definition.description
        upgrade_flow.add({
          type = "label",
          caption = {"ii-gui." .. desc_key, string.format("%.0f", effect_display)},
        })

        upgrade_flow.add({
          type = "label",
          caption = {"ii-gui.current-level", upgrade.current_level},
          style = "description_label",
        })
      end

      container.add({type = "line"})
    end
  end
end

-- Populate the imports tab
function GUI.populate_imports_tab(container)
  container.clear()

  local TradeHub = require("scripts.trade-hub")
  local available = TradeHub.get_available_imports()

  container.add({
    type = "label",
    caption = {"ii-gui.import-select"},
    style = "heading_2_label",
  })

  for _, material in pairs(available) do
    local mat_flow = container.add({type = "flow", direction = "horizontal"})
    mat_flow.style.vertical_align = "center"

    mat_flow.add({
      type = "sprite",
      sprite = "item/" .. material.name,
    })

    local item_proto = game.item_prototypes[material.name]
    local item_name = item_proto and item_proto.localised_name or material.name

    mat_flow.add({
      type = "label",
      caption = item_name,
    })

    mat_flow.add({
      type = "label",
      caption = "(Tier " .. material.tier .. ")",
      style = "description_label",
    })
  end

  container.add({type = "line"})
  container.add({
    type = "label",
    caption = "Click on an Import Chest in-game to configure which material it produces.",
    style = "description_label",
  })
end

-- Populate the statistics tab
function GUI.populate_statistics_tab(container)
  container.clear()

  local stats = global.ii_data.statistics or {}

  container.add({type = "label", caption = {"ii-gui.statistics-total-earned"}, style = "heading_3_label"})
  container.add({type = "label", caption = GUI.format_number(stats.total_earned or 0) .. " credits"})

  container.add({type = "line"})

  container.add({type = "label", caption = {"ii-gui.statistics-orders-completed"}, style = "heading_3_label"})
  container.add({type = "label", caption = GUI.format_number(stats.orders_completed or 0)})

  container.add({type = "line"})

  container.add({type = "label", caption = {"ii-gui.statistics-items-exported"}, style = "heading_3_label"})
  container.add({type = "label", caption = GUI.format_number(stats.items_exported or 0)})
end

-- Handle GUI click events
function GUI.on_click(event)
  local element = event.element
  if not element or not element.valid then return end

  local player = game.get_player(event.player_index)
  if not player then return end

  local name = element.name

  if name == TOGGLE_BUTTON_NAME or name == "ii-toggle-gui" then
    GUI.toggle(player)

  elseif name == "ii_close_button" then
    local main_frame = player.gui.screen[MAIN_FRAME_NAME]
    if main_frame then
      main_frame.destroy()
    end

  elseif name == "ii_reroll_orders" then
    local Orders = require("scripts.orders")
    local cost = Orders.get_reroll_cost()
    local success, err = Orders.reroll_orders(cost)
    if not success then
      player.print({"ii-messages." .. err})
    end
    GUI.refresh(player)

  elseif string.find(name, "ii_buy_upgrade_") then
    local upgrade_name = string.sub(name, 16)  -- Remove "ii_buy_upgrade_" prefix
    local Upgrades = require("scripts.upgrades")
    local success, err = Upgrades.purchase(upgrade_name)
    if success then
      player.print({"ii-messages.upgrade-purchased"})
    else
      player.print({"ii-messages." .. err})
    end
    GUI.refresh(player)
  end
end

-- Handle GUI closed event
function GUI.on_closed(event)
  local element = event.element
  if not element or not element.valid then return end

  if element.name == MAIN_FRAME_NAME then
    element.destroy()
  end
end

-- Refresh the GUI
function GUI.refresh(player)
  local main_frame = player.gui.screen[MAIN_FRAME_NAME]
  if main_frame then
    GUI.create_main_frame(player)
  end
end

-- Format large numbers with suffixes
function GUI.format_number(num)
  if num >= 1000000000 then
    return string.format("%.2fB", num / 1000000000)
  elseif num >= 1000000 then
    return string.format("%.2fM", num / 1000000)
  elseif num >= 1000 then
    return string.format("%.1fK", num / 1000)
  else
    return tostring(math.floor(num))
  end
end

-- Handle shortcut (toolbar button)
script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == "ii-toggle-gui" then
    local player = game.get_player(event.player_index)
    if player then
      GUI.toggle(player)
    end
  end
end)

return GUI
