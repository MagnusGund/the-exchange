# CLAUDE.md - AI Assistant Guide for Incremental Industrialist

## Repository Overview

**Mod Name:** Incremental Industrialist
**Internal Name:** `incremental-industrialist`
**Factorio Version:** 2.0+ (Space Age required)
**Current Version:** 0.1.0

A new planet mod for Factorio Space Age. The Exchange is an incremental game layer where players import materials, fulfill orders, earn credits, and unlock permanent factory-wide bonuses through Commerce Science.

## Project Structure

```
incremental-industrialist/
├── info.json              # Mod metadata (Space Age dependency)
├── data.lua               # Data stage entry point
├── control.lua            # Control stage entry point
├── settings.lua           # Mod settings
├── changelog.txt          # Version history
├── README.md              # User documentation
├── CLAUDE.md              # AI assistant guide
├── prototypes/
│   ├── planet.lua         # The Exchange planet definition
│   ├── items.lua          # Exchange Data, Data Matrix, Commerce Science
│   ├── recipes.lua        # Crafting recipes
│   ├── import-chest.lua   # Import Chest entity (blue tint)
│   ├── export-chest.lua   # Export Chest entity (orange tint)
│   ├── data-terminal.lua  # Data Terminal entity (purple tint)
│   ├── technologies.lua   # Tech tree + infinite research
│   └── shortcuts.lua      # GUI shortcuts (Shift+I, Shift+O)
├── scripts/
│   ├── trade-hub.lua      # Import/export/terminal processing
│   ├── orders.lua         # Order generation and completion
│   ├── upgrades.lua       # Upgrade system and force modifiers
│   └── gui.lua            # 5-tab user interface
├── locale/
│   └── en/locale.cfg      # English translations
└── graphics/              # Placeholder for custom graphics
```

## Core Systems

### 1. The Exchange Planet
- New Space Age planet, no hazards, no enemies
- Small bootstrap ore patches, always daytime
- Accessible via planet discovery research

### 2. Trade System (`scripts/trade-hub.lua`)
- Import chests: generate materials, output to belts
- Export chests: accept products, match to orders
- Data terminals: convert credits → Exchange Data
- 5 material tiers (ore → plate → intermediate → advanced → high-tech)

### 3. Order System (`scripts/orders.lua`)
- 5 complexity tiers, 5 size tiers
- Progressive scaling based on completion history
- Reroll functionality with scaling cost

### 4. Commerce Science Loop
```
Export Orders → Credits → Exchange Data → Data Matrix → Commerce Science
                                                              ↓
                                              Infinite Research (Global Bonuses)
```

## Key Data Structures

### global.ii_data
```lua
{
  credits = 0,
  import_chests = {},       -- unit_number -> {entity, material, ...}
  export_chests = {},       -- unit_number -> {entity, ...}
  data_terminals = {},      -- unit_number -> {entity, auto_purchase, ...}
  active_orders = {},       -- order_id -> order data
  order_progress = {},      -- item_name -> completion count
  unlocked_imports = {},    -- material tiers unlocked
  exchange_data_purchased = 0,
  statistics = {...},
}
```

## Naming Conventions

- **Prototypes:** Prefix with `ii-` (e.g., `ii-import-chest`)
- **Locale keys:** Prefix with `ii-` (e.g., `ii-gui.title`)
- **Global data:** Use `global.ii_data` as namespace
- **GUI elements:** Prefix with `ii_` (e.g., `ii_main_frame`)

## Testing Commands

```lua
-- Add credits
/c remote.call("incremental-industrialist", "add_credits", 10000)

-- View credits
/c game.print(remote.call("incremental-industrialist", "get_credits"))

-- View orders
/c game.print(serpent.block(remote.call("incremental-industrialist", "get_active_orders")))
```

## Code Style

- 2-space indentation
- `snake_case` for functions/variables
- `UPPER_CASE` for constants
- Nil checks before entity/player access
- Use `on_nth_tick` over `on_tick`
