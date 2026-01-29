-- Shortcut Prototypes
-- Quick access buttons for the mod GUI

data:extend({
  {
    type = "shortcut",
    name = "ii-toggle-gui",
    order = "a[ii]-a[toggle]",
    action = "lua",
    icon = "__base__/graphics/icons/signal/signal_I.png",
    icon_size = 64,
    small_icon = "__base__/graphics/icons/signal/signal_I.png",
    small_icon_size = 64,
    toggleable = true,
  },
})
