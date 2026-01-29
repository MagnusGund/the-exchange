# CLAUDE.md - AI Assistant Guide for Incremental Industrialist

## Repository Overview

**Mod Name:** Incremental Industrialist
**Internal Name:** `incremental-industrialist`
**Repository:** MagnusGund/factorio-mod
**Factorio Version:** 2.0+ (Space Age required)
**Current Version:** 0.1.0

An incremental game layer for Factorio Space Age. Import raw materials, fulfill production orders, earn credits, and unlock permanent factory upgrades.

## Project Structure

```
factorio-mod/
├── info.json              # Mod metadata
├── data.lua               # Data stage entry point
├── control.lua            # Control stage entry point
├── settings.lua           # Mod settings
├── changelog.txt          # Version history
├── README.md              # User documentation
├── CLAUDE.md              # AI assistant guide (this file)
├── prototypes/
│   ├── trade-hub.lua      # Trade Hub entity/item/recipe
│   ├── import-chest.lua   # Import Chest entity/item/recipe
│   ├── export-chest.lua   # Export Chest entity/item/recipe
│   ├── technologies.lua   # Research tree additions
│   └── shortcuts.lua      # Toolbar shortcuts
├── scripts/
│   ├── trade-hub.lua      # Import/export processing logic
│   ├── orders.lua         # Order system and rewards
│   ├── upgrades.lua       # Upgrade definitions and application
│   └── gui.lua            # User interface
├── locale/
│   └── en/
│       └── locale.cfg     # English translations
└── graphics/              # (Placeholder for custom graphics)
    ├── icons/
    └── entity/
```

## Core Systems

### 1. Trade Hub System (`scripts/trade-hub.lua`)
- Central entity for managing imports/exports
- Tracks all placed import/export chests via `global.ii_data`
- Processes imports on `on_nth_tick(30)` (every 0.5 seconds)
- Outputs items directly to adjacent belts when chests are full

### 2. Order System (`scripts/orders.lua`)
- Progressive order templates (Tier 1-5 complexity)
- Size tiers: small → medium → large → huge → massive
- Orders scale based on player's completion history per item type
- Rewards scale super-linearly to incentivize larger orders

### 3. Upgrade System (`scripts/upgrades.lua`)
- Categories: imports, exports, factory bonuses
- Cost scaling with exponential formula: `base_cost * (scaling ^ level)`
- Factory bonuses apply via Factorio's `force` modifiers
- Robot upgrades gated behind `ii-robot-logistics-bonus` technology

### 4. GUI System (`scripts/gui.lua`)
- Toggle button in top-left corner
- Tabbed interface: Orders, Upgrades, Imports, Statistics
- Real-time progress bars for active orders
- Number formatting with K/M/B suffixes

## Key Data Structures

### global.ii_data
```lua
{
  credits = 0,                    -- Current currency
  import_chests = {},             -- unit_number -> chest data
  export_chests = {},             -- unit_number -> chest data
  active_orders = {},             -- order_id -> order data
  completed_orders = {},          -- order_id -> completed order
  order_progress = {},            -- item_name -> completion count
  unlocked_order_tiers = {1},     -- Available order tiers
  upgrades = {
    imports = {},                 -- Unlocked import materials
    import_tiers = {},            -- Upgraded material tiers
    import_rate = 1.0,            -- Import speed multiplier
    order_slots = 3,              -- Concurrent order limit
    factory = {},                 -- Factory bonus values
  },
  upgrade_levels = {},            -- upgrade_name -> level
  statistics = {},                -- Tracking metrics
}
```

## Naming Conventions

- **Prototypes:** Prefix with `ii-` (e.g., `ii-trade-hub`, `ii-import-chest`)
- **Locale keys:** Prefix with `ii-` (e.g., `ii-gui.title`, `ii-messages.order-completed`)
- **Global data:** Use `global.ii_data` as root namespace
- **GUI elements:** Prefix names with `ii_` (e.g., `ii_main_frame`)

## Development Tasks

### Adding New Importable Materials
1. Add entry to `TradeHub.IMPORT_MATERIALS` in `scripts/trade-hub.lua`
2. Specify tier, category, and prerequisites
3. Update locale if needed

### Adding New Order Templates
1. Add entry to `Orders.ORDER_TEMPLATES` in `scripts/orders.lua`
2. Specify item name, base amount, reward per item, and tier
3. Tie to appropriate research in `Upgrades.on_research_finished()`

### Adding New Upgrades
1. Add definition to `Upgrades.DEFINITIONS` in `scripts/upgrades.lua`
2. Handle application in `Upgrades.apply_upgrade()`
3. Add locale strings for description
4. Update GUI if category doesn't exist

### Adding New Technologies
1. Add prototype to `prototypes/technologies.lua`
2. Handle unlock effects in `scripts/upgrades.lua` → `on_research_finished()`
3. Add locale strings

## Testing Checklist

- [ ] New game starts with correct initial state
- [ ] Trade Hub can be crafted after green science research
- [ ] Import chests spawn items at configured rate
- [ ] Export chests correctly match items to active orders
- [ ] Orders complete and grant correct rewards
- [ ] Upgrades purchase and apply correctly
- [ ] GUI displays accurate information
- [ ] Save/load preserves all mod data
- [ ] Multiplayer: All players see consistent state

## Known Limitations (v0.1.0)

1. **Placeholder graphics:** Currently using tinted base game icons
2. **Import chest GUI:** No in-game GUI for selecting materials (requires console or API)
3. **Assembler speed bonus:** Currently uses placeholder implementation
4. **No Space Age materials:** Holmium, tungsten, etc. not yet in import tree

## Future Enhancements

- Custom graphics for all entities
- In-game material selector for import chests
- Space Age material imports tied to planet discovery
- Achievement system for milestones
- Sound effects for order completion
- More granular factory bonuses (per-machine-type)

## Code Style

- 2-space indentation
- `snake_case` for functions and variables
- `UPPER_CASE` for constants
- Explicit `local` for all local variables
- Nil checks before accessing entity/player properties
- Use `on_nth_tick` instead of `on_tick` for performance

## Useful Commands (In-game Console)

```lua
-- Add credits for testing
/c remote.call("incremental-industrialist", "add_credits", 10000)

-- View current credits
/c game.print(remote.call("incremental-industrialist", "get_credits"))

-- View upgrade state
/c game.print(serpent.block(remote.call("incremental-industrialist", "get_upgrades")))

-- Reload mods
/c game.reload_mods()
```

## Resources

- [Factorio 2.0 API Documentation](https://lua-api.factorio.com/latest/)
- [Factorio Prototype Documentation](https://wiki.factorio.com/Prototype_definitions)
- [Space Age Modding Guide](https://wiki.factorio.com/Tutorial:Space_age_modding)
