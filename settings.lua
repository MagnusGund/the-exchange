-- Incremental Industrialist - Mod Settings

data:extend({
  {
    type = "int-setting",
    name = "ii-import-tick-rate",
    setting_type = "runtime-global",
    default_value = 30,
    minimum_value = 10,
    maximum_value = 120,
    order = "a-a"
  },
  {
    type = "int-setting",
    name = "ii-base-import-amount",
    setting_type = "runtime-global",
    default_value = 1,
    minimum_value = 1,
    maximum_value = 10,
    order = "a-b"
  },
  {
    type = "int-setting",
    name = "ii-starting-credits",
    setting_type = "runtime-global",
    default_value = 100,
    minimum_value = 0,
    maximum_value = 10000,
    order = "a-c"
  },
  {
    type = "int-setting",
    name = "ii-max-active-orders",
    setting_type = "runtime-global",
    default_value = 3,
    minimum_value = 1,
    maximum_value = 10,
    order = "a-d"
  },
  {
    type = "bool-setting",
    name = "ii-show-tutorial-tips",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "b-a"
  },
  {
    type = "double-setting",
    name = "ii-data-terminal-conversion-rate",
    setting_type = "runtime-global",
    default_value = 100,
    minimum_value = 10,
    maximum_value = 1000,
    order = "c-a"
  },
  {
    type = "double-setting",
    name = "ii-data-terminal-scaling-factor",
    setting_type = "runtime-global",
    default_value = 1.05,
    minimum_value = 1.0,
    maximum_value = 2.0,
    order = "c-b"
  }
})
