-- Incremental Industrialist - Toolbar Shortcuts

data:extend({
  -- Main GUI toggle shortcut
  {
    type = "shortcut",
    name = "ii-toggle-gui",
    order = "z[incremental]-a[toggle-gui]",
    action = "lua",
    localised_name = {"shortcut.ii-toggle-gui"},
    icon = "__base__/graphics/icons/signal/signal-I.png",
    icon_size = 64,
    small_icon = "__base__/graphics/icons/signal/signal-I.png",
    small_icon_size = 64,
    toggleable = true
  },
  
  -- Quick orders shortcut
  {
    type = "shortcut",
    name = "ii-quick-orders",
    order = "z[incremental]-b[quick-orders]",
    action = "lua",
    localised_name = {"shortcut.ii-quick-orders"},
    icon = "__base__/graphics/icons/signal/signal-O.png",
    icon_size = 64,
    small_icon = "__base__/graphics/icons/signal/signal-O.png",
    small_icon_size = 64
  }
})

-- Custom inputs (keybindings)
data:extend({
  {
    type = "custom-input",
    name = "ii-toggle-gui-key",
    key_sequence = "SHIFT + I",
    consuming = "none",
    localised_name = {"controls.ii-toggle-gui-key"}
  },
  {
    type = "custom-input",
    name = "ii-quick-accept-order",
    key_sequence = "SHIFT + O",
    consuming = "none",
    localised_name = {"controls.ii-quick-accept-order"}
  }
})
