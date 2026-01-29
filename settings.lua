-- Incremental Industrialist - Settings Stage
-- Mod configuration options

data:extend({
  {
    type = "int-setting",
    name = "ii-base-import-rate",
    setting_type = "runtime-global",
    default_value = 2,
    minimum_value = 1,
    maximum_value = 10,
    order = "a-a",
  },
  {
    type = "int-setting",
    name = "ii-starting-order-slots",
    setting_type = "runtime-global",
    default_value = 3,
    minimum_value = 1,
    maximum_value = 10,
    order = "a-b",
  },
  {
    type = "bool-setting",
    name = "ii-show-tutorial-tips",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "b-a",
  },
})
