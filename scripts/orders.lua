-- Incremental Industrialist - Order System
-- Progressive order templates with scaling rewards

local Orders = {}

-- Order templates by tier
Orders.ORDER_TEMPLATES = {
  -- Tier 1: Basic raw materials and simple products
  {item = "iron-plate", base_amount = 100, reward_per_item = 1, tier = 1},
  {item = "copper-plate", base_amount = 100, reward_per_item = 1, tier = 1},
  {item = "stone-brick", base_amount = 50, reward_per_item = 2, tier = 1},
  {item = "iron-gear-wheel", base_amount = 50, reward_per_item = 3, tier = 1},
  {item = "copper-cable", base_amount = 200, reward_per_item = 0.5, tier = 1},
  
  -- Tier 2: Intermediate products
  {item = "electronic-circuit", base_amount = 50, reward_per_item = 5, tier = 2},
  {item = "steel-plate", base_amount = 50, reward_per_item = 5, tier = 2},
  {item = "pipe", base_amount = 100, reward_per_item = 2, tier = 2},
  {item = "iron-stick", base_amount = 200, reward_per_item = 1, tier = 2},
  {item = "transport-belt", base_amount = 100, reward_per_item = 3, tier = 2},
  
  -- Tier 3: Advanced intermediates
  {item = "advanced-circuit", base_amount = 25, reward_per_item = 15, tier = 3},
  {item = "engine-unit", base_amount = 20, reward_per_item = 20, tier = 3},
  {item = "plastic-bar", base_amount = 100, reward_per_item = 5, tier = 3},
  {item = "sulfur", base_amount = 100, reward_per_item = 3, tier = 3},
  {item = "battery", base_amount = 50, reward_per_item = 10, tier = 3},
  {item = "inserter", base_amount = 50, reward_per_item = 8, tier = 3},
  {item = "fast-inserter", base_amount = 30, reward_per_item = 15, tier = 3},
  
  -- Tier 4: High-tech products
  {item = "processing-unit", base_amount = 10, reward_per_item = 50, tier = 4},
  {item = "electric-engine-unit", base_amount = 20, reward_per_item = 30, tier = 4},
  {item = "flying-robot-frame", base_amount = 10, reward_per_item = 75, tier = 4},
  {item = "low-density-structure", base_amount = 20, reward_per_item = 40, tier = 4},
  {item = "rocket-fuel", base_amount = 50, reward_per_item = 25, tier = 4},
  {item = "assembling-machine-2", base_amount = 20, reward_per_item = 50, tier = 4},
  
  -- Tier 5: End-game products
  {item = "rocket-control-unit", base_amount = 10, reward_per_item = 100, tier = 5},
  {item = "solar-panel", base_amount = 50, reward_per_item = 40, tier = 5},
  {item = "accumulator", base_amount = 50, reward_per_item = 35, tier = 5},
  {item = "speed-module", base_amount = 20, reward_per_item = 50, tier = 5},
  {item = "productivity-module", base_amount = 20, reward_per_item = 50, tier = 5},
  {item = "effectivity-module", base_amount = 20, reward_per_item = 50, tier = 5},
  {item = "speed-module-2", base_amount = 10, reward_per_item = 150, tier = 5},
  {item = "productivity-module-2", base_amount = 10, reward_per_item = 150, tier = 5}
}

-- Size tier multipliers
Orders.SIZE_TIERS = {
  {name = "small", multiplier = 1.0, reward_bonus = 1.0},
  {name = "medium", multiplier = 2.5, reward_bonus = 1.2},
  {name = "large", multiplier = 5.0, reward_bonus = 1.5},
  {name = "huge", multiplier = 10.0, reward_bonus = 2.0},
  {name = "massive", multiplier = 25.0, reward_bonus = 3.0}
}

-- Order ID counter
local order_id_counter = 0

-- Generate a unique order ID
local function generate_order_id()
  order_id_counter = order_id_counter + 1
  return "order_" .. game.tick .. "_" .. order_id_counter
end

-- Get available order templates for player's unlocked tiers
function Orders.get_available_templates()
  local unlocked_tiers = global.ii_data.unlocked_order_tiers or {1}
  local available = {}
  
  for _, template in ipairs(Orders.ORDER_TEMPLATES) do
    for _, tier in ipairs(unlocked_tiers) do
      if template.tier <= tier then
        table.insert(available, template)
        break
      end
    end
  end
  
  return available
end

-- Generate a new random order
function Orders.generate_order(preferred_tier, preferred_size)
  local available = Orders.get_available_templates()
  if #available == 0 then return nil end
  
  -- Filter by preferred tier if specified
  local filtered = {}
  if preferred_tier then
    for _, template in ipairs(available) do
      if template.tier == preferred_tier then
        table.insert(filtered, template)
      end
    end
    if #filtered == 0 then
      filtered = available
    end
  else
    filtered = available
  end
  
  -- Select random template
  local template = filtered[math.random(#filtered)]
  
  -- Determine size tier
  local size_index = preferred_size or math.random(#Orders.SIZE_TIERS)
  local size_tier = Orders.SIZE_TIERS[size_index]
  
  -- Calculate scaled amount and reward
  local item_progress = global.ii_data.order_progress[template.item] or 0
  local progress_scaling = 1 + (item_progress * 0.1) -- 10% increase per completed order of this type
  
  local amount = math.floor(template.base_amount * size_tier.multiplier * progress_scaling)
  local reward_per_item = template.reward_per_item * size_tier.reward_bonus
  local total_reward = math.floor(amount * reward_per_item)
  
  local order = {
    id = generate_order_id(),
    item = template.item,
    amount = amount,
    delivered = 0,
    reward = total_reward,
    tier = template.tier,
    size_tier = size_tier.name,
    created_tick = game.tick,
    expires_tick = nil -- No expiration for now
  }
  
  return order
end

-- Accept an order (add to active orders)
function Orders.accept_order(order)
  local max_orders = global.ii_data.upgrades.order_slots or 3
  local active_count = 0
  
  for _ in pairs(global.ii_data.active_orders) do
    active_count = active_count + 1
  end
  
  if active_count >= max_orders then
    return false, "Maximum active orders reached"
  end
  
  global.ii_data.active_orders[order.id] = order
  return true
end

-- Complete an order
function Orders.complete_order(order_id)
  local order = global.ii_data.active_orders[order_id]
  if not order then return false end
  
  -- Award credits
  local TradeHub = require("scripts.trade-hub")
  TradeHub.add_credits(order.reward)
  
  -- Update statistics
  global.ii_data.statistics.total_orders_completed = 
    global.ii_data.statistics.total_orders_completed + 1
  
  -- Update item progress
  global.ii_data.order_progress[order.item] = 
    (global.ii_data.order_progress[order.item] or 0) + 1
  
  -- Move to completed orders
  order.completed_tick = game.tick
  global.ii_data.completed_orders[order_id] = order
  global.ii_data.active_orders[order_id] = nil
  
  -- Notify players
  for _, player in pairs(game.players) do
    player.print({"ii-messages.order-completed", order.item, order.amount, order.reward})
  end
  
  return true
end

-- Cancel an order
function Orders.cancel_order(order_id)
  local order = global.ii_data.active_orders[order_id]
  if not order then return false end
  
  -- Return partial credit for delivered items (50%)
  if order.delivered > 0 then
    local partial_reward = math.floor((order.delivered / order.amount) * order.reward * 0.5)
    if partial_reward > 0 then
      local TradeHub = require("scripts.trade-hub")
      TradeHub.add_credits(partial_reward)
    end
  end
  
  global.ii_data.active_orders[order_id] = nil
  return true
end

-- Get active orders
function Orders.get_active_orders()
  return global.ii_data.active_orders
end

-- Get order by ID
function Orders.get_order(order_id)
  return global.ii_data.active_orders[order_id]
end

-- Get completed orders count for an item
function Orders.get_item_progress(item_name)
  return global.ii_data.order_progress[item_name] or 0
end

-- Unlock a new order tier
function Orders.unlock_tier(tier)
  local tiers = global.ii_data.unlocked_order_tiers
  for _, t in ipairs(tiers) do
    if t == tier then
      return false -- Already unlocked
    end
  end
  table.insert(tiers, tier)
  table.sort(tiers)
  return true
end

-- Get current unlocked tiers
function Orders.get_unlocked_tiers()
  return global.ii_data.unlocked_order_tiers
end

-- Get max unlocked tier
function Orders.get_max_tier()
  local max = 1
  for _, tier in ipairs(global.ii_data.unlocked_order_tiers) do
    if tier > max then max = tier end
  end
  return max
end

-- Format order for display
function Orders.format_order(order)
  local progress = order.delivered / order.amount
  return {
    item = order.item,
    amount = order.amount,
    delivered = order.delivered,
    progress = progress,
    reward = order.reward,
    tier = order.tier,
    size_tier = order.size_tier
  }
end

return Orders
