-- Order System
-- Manages production orders and rewards

local Orders = {}

-- Order templates with scaling factors
Orders.ORDER_TEMPLATES = {
  -- Early game items (Tier 1)
  {item = "iron-gear-wheel", base_amount = 100, reward_per_item = 0.3, tier = 1},
  {item = "iron-stick", base_amount = 200, reward_per_item = 0.1, tier = 1},
  {item = "copper-cable", base_amount = 200, reward_per_item = 0.1, tier = 1},
  {item = "stone-brick", base_amount = 100, reward_per_item = 0.2, tier = 1},

  -- Early-mid game (Tier 2)
  {item = "electronic-circuit", base_amount = 100, reward_per_item = 0.8, tier = 2},
  {item = "transport-belt", base_amount = 100, reward_per_item = 0.5, tier = 2},
  {item = "inserter", base_amount = 50, reward_per_item = 1.0, tier = 2},
  {item = "pipe", base_amount = 100, reward_per_item = 0.3, tier = 2},

  -- Mid game (Tier 3)
  {item = "advanced-circuit", base_amount = 50, reward_per_item = 3.0, tier = 3},
  {item = "engine-unit", base_amount = 30, reward_per_item = 5.0, tier = 3},
  {item = "electric-engine-unit", base_amount = 20, reward_per_item = 8.0, tier = 3},
  {item = "steel-plate", base_amount = 100, reward_per_item = 1.0, tier = 3},

  -- Late game (Tier 4)
  {item = "processing-unit", base_amount = 20, reward_per_item = 15.0, tier = 4},
  {item = "low-density-structure", base_amount = 20, reward_per_item = 20.0, tier = 4},
  {item = "flying-robot-frame", base_amount = 10, reward_per_item = 25.0, tier = 4},

  -- End game (Tier 5)
  {item = "rocket-control-unit", base_amount = 10, reward_per_item = 50.0, tier = 5},
  {item = "rocket-fuel", base_amount = 20, reward_per_item = 30.0, tier = 5},
}

-- Order size multipliers
Orders.SIZE_TIERS = {
  {name = "small", multiplier = 1, reward_bonus = 1.0},
  {name = "medium", multiplier = 5, reward_bonus = 1.2},
  {name = "large", multiplier = 25, reward_bonus = 1.5},
  {name = "huge", multiplier = 100, reward_bonus = 2.0},
  {name = "massive", multiplier = 500, reward_bonus = 3.0},
}

local next_order_id = 1

-- Initialize the order system
function Orders.initialize()
  global.ii_data.active_orders = global.ii_data.active_orders or {}
  global.ii_data.completed_orders = global.ii_data.completed_orders or {}
  global.ii_data.order_progress = global.ii_data.order_progress or {}
  global.ii_data.unlocked_order_tiers = global.ii_data.unlocked_order_tiers or {1}  -- Start with tier 1

  -- Generate initial orders
  if table_size(global.ii_data.active_orders) == 0 then
    local slots = global.ii_data.upgrades.order_slots or 3
    for i = 1, slots do
      Orders.generate_order()
    end
  end
end

-- Generate a new random order based on unlocked tiers
function Orders.generate_order()
  local unlocked_tiers = global.ii_data.unlocked_order_tiers or {1}
  local order_progress = global.ii_data.order_progress or {}

  -- Filter templates to unlocked tiers
  local available_templates = {}
  for _, template in pairs(Orders.ORDER_TEMPLATES) do
    for _, tier in pairs(unlocked_tiers) do
      if template.tier == tier then
        table.insert(available_templates, template)
        break
      end
    end
  end

  if #available_templates == 0 then
    return nil
  end

  -- Pick a random template
  local template = available_templates[math.random(#available_templates)]

  -- Determine size tier based on progress for this item
  local item_progress = order_progress[template.item] or 0
  local size_tier_index = math.min(item_progress + 1, #Orders.SIZE_TIERS)
  local size_tier = Orders.SIZE_TIERS[size_tier_index]

  -- Calculate order details
  local amount = math.floor(template.base_amount * size_tier.multiplier)
  local reward = math.floor(template.base_amount * template.reward_per_item * size_tier.multiplier * size_tier.reward_bonus)

  -- Create the order
  local order = {
    id = next_order_id,
    item = template.item,
    required = amount,
    delivered = 0,
    reward = reward,
    size_tier = size_tier.name,
    template_tier = template.tier,
  }

  next_order_id = next_order_id + 1
  global.ii_data.active_orders[order.id] = order

  return order
end

-- Complete an order and grant rewards
function Orders.complete_order(order_id)
  local order = global.ii_data.active_orders[order_id]
  if not order then return end

  -- Grant credits
  global.ii_data.credits = global.ii_data.credits + order.reward

  -- Update statistics
  global.ii_data.completed_orders[order_id] = order
  global.ii_data.statistics = global.ii_data.statistics or {}
  global.ii_data.statistics.total_earned = (global.ii_data.statistics.total_earned or 0) + order.reward
  global.ii_data.statistics.orders_completed = (global.ii_data.statistics.orders_completed or 0) + 1
  global.ii_data.statistics.items_exported = (global.ii_data.statistics.items_exported or 0) + order.required

  -- Increase order progress for this item (unlocks larger orders)
  global.ii_data.order_progress[order.item] = (global.ii_data.order_progress[order.item] or 0) + 1

  -- Remove from active orders
  global.ii_data.active_orders[order_id] = nil

  -- Notify players
  for _, player in pairs(game.players) do
    player.print({"ii-messages.order-completed", order.reward})
  end

  -- Generate a replacement order
  Orders.generate_order()
end

-- Reroll all orders (costs credits)
function Orders.reroll_orders(cost)
  if global.ii_data.credits < cost then
    return false, "not-enough-credits"
  end

  global.ii_data.credits = global.ii_data.credits - cost
  global.ii_data.active_orders = {}

  local slots = global.ii_data.upgrades.order_slots or 3
  for i = 1, slots do
    Orders.generate_order()
  end

  return true
end

-- Get reroll cost (scales with progression)
function Orders.get_reroll_cost()
  local completed = global.ii_data.statistics and global.ii_data.statistics.orders_completed or 0
  local base_cost = 50
  local scaling = math.floor(completed / 10) * 25
  return base_cost + scaling
end

-- Unlock a new order tier
function Orders.unlock_tier(tier)
  global.ii_data.unlocked_order_tiers = global.ii_data.unlocked_order_tiers or {}
  for _, t in pairs(global.ii_data.unlocked_order_tiers) do
    if t == tier then return end  -- Already unlocked
  end
  table.insert(global.ii_data.unlocked_order_tiers, tier)
end

-- Get active orders
function Orders.get_active_orders()
  return global.ii_data.active_orders or {}
end

return Orders
