# CLAUDE.md - AI Assistant Guide for factorio-mod

## Repository Overview

This is a Factorio mod repository in early development. Factorio mods extend the game's functionality using Lua scripts and JSON configuration files.

**Repository:** MagnusGund/factorio-mod
**Current Status:** Initial setup - core mod files need to be created

## Project Structure

### Current State
```
factorio-mod/
├── README.md          # Project documentation
└── CLAUDE.md          # This file - AI assistant guide
```

### Target Factorio Mod Structure
A complete Factorio mod should have:
```
factorio-mod/
├── info.json          # Required: Mod metadata (name, version, dependencies)
├── control.lua        # Runtime game logic and event handlers
├── data.lua           # Prototype definitions (items, recipes, entities)
├── data-updates.lua   # Late-stage prototype modifications
├── data-final-fixes.lua # Final prototype adjustments
├── settings.lua       # Mod settings definitions
├── settings-updates.lua # Late-stage settings modifications
├── locale/
│   └── en/
│       └── locale.cfg # English translations
├── graphics/          # Sprites, icons, and images
├── migrations/        # Save migration scripts
├── changelog.txt      # Version history
├── README.md          # Documentation
└── CLAUDE.md          # AI assistant guide
```

## Factorio Modding Essentials

### Required File: info.json
```json
{
  "name": "mod-internal-name",
  "version": "0.1.0",
  "title": "Mod Display Name",
  "author": "AuthorName",
  "factorio_version": "1.1",
  "dependencies": ["base >= 1.1.0"],
  "description": "Brief mod description"
}
```

### Load Order and Stages
Factorio loads mods in three stages:

1. **Settings Stage** (`settings.lua`, `settings-updates.lua`, `settings-final-fixes.lua`)
   - Defines mod settings before data loading
   - Access via `settings.startup`, `settings.runtime-global`, `settings.runtime-per-user`

2. **Data Stage** (`data.lua`, `data-updates.lua`, `data-final-fixes.lua`)
   - Defines prototypes: items, recipes, entities, technologies
   - No game state access - purely declarative
   - Use `data:extend({...})` to add prototypes

3. **Control Stage** (`control.lua`)
   - Runtime game logic
   - Event handlers for game events
   - Access to `game`, `script`, `remote`, `commands`, `rendering` globals

### Key Globals by Stage

**Data Stage:**
- `data` - Prototype registration
- `mods` - Table of loaded mod names/versions
- `settings` - Startup settings values

**Control Stage:**
- `game` - Game state access
- `script` - Event registration
- `remote` - Inter-mod communication
- `commands` - Console commands
- `rendering` - Drawing API
- `global` - Persistent mod data (survives save/load)

## Code Conventions

### Lua Style Guidelines
- Use `snake_case` for variables and functions
- Use `PascalCase` for prototype type names
- Use `UPPER_CASE` for constants
- Prefix local functions with `local`
- Use 2-space indentation (Factorio convention)

### Prototype Naming
- Internal names: `mod-name-item-name` (kebab-case with mod prefix)
- Avoid conflicts by prefixing all prototype names with mod identifier
- Example: `my-mod-advanced-furnace`

### Event Handling Pattern
```lua
-- control.lua
local function on_player_created(event)
  local player = game.get_player(event.player_index)
  -- Handle player creation
end

script.on_event(defines.events.on_player_created, on_player_created)
```

### Global Data Pattern
```lua
-- Initialize global data structure
script.on_init(function()
  global.my_mod_data = global.my_mod_data or {}
end)

script.on_configuration_changed(function(data)
  -- Handle mod updates and migrations
  global.my_mod_data = global.my_mod_data or {}
end)
```

## Development Workflow

### Testing Locally
1. Symlink or copy mod folder to Factorio mods directory:
   - Windows: `%APPDATA%\Factorio\mods\`
   - Linux: `~/.factorio/mods/`
   - macOS: `~/Library/Application Support/factorio/mods/`
2. Restart Factorio or use `/c game.reload_mods()` in console
3. Check `factorio-current.log` for errors

### Debugging
- Use `log("message")` for logging to factorio-current.log
- Use `game.print("message")` for in-game console output
- Use `serpent.block(table)` to dump table contents
- Enable `show-fps` and check performance with large mods

### Version Bumping
1. Update `version` in `info.json`
2. Add entry to `changelog.txt`
3. Test migrations if save format changed

## Common Patterns

### Adding an Item and Recipe
```lua
-- data.lua
data:extend({
  {
    type = "item",
    name = "my-mod-special-item",
    icon = "__my-mod__/graphics/icons/special-item.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "a[my-mod]-a[special-item]",
    stack_size = 100
  },
  {
    type = "recipe",
    name = "my-mod-special-item",
    enabled = false,  -- Unlocked by technology
    ingredients = {
      {"iron-plate", 5},
      {"copper-plate", 3}
    },
    result = "my-mod-special-item"
  }
})
```

### Modifying Existing Prototypes
```lua
-- data-updates.lua
local iron_plate = data.raw["item"]["iron-plate"]
if iron_plate then
  iron_plate.stack_size = 200
end
```

### Remote Interface
```lua
-- control.lua
remote.add_interface("my-mod", {
  get_data = function()
    return global.my_mod_data
  end,
  set_value = function(key, value)
    global.my_mod_data[key] = value
  end
})
```

## File Reference Paths

In data stage files, use special path syntax:
- `__mod-name__/path/to/file` - Reference files in another mod
- `__base__/graphics/...` - Reference base game assets
- `__core__/graphics/...` - Reference core game assets

## Dependencies

In `info.json`, specify dependencies:
- `"mod-name"` - Required dependency
- `"? mod-name"` - Optional dependency
- `"(?) mod-name"` - Hidden optional dependency
- `"! mod-name"` - Incompatible mod
- `"~ mod-name"` - Does not affect load order
- `">= 1.0.0"` - Version constraints

## AI Assistant Guidelines

### When Adding Features
1. Check if similar functionality exists in base game or popular mods
2. Follow established naming conventions with mod prefix
3. Add localization strings for all user-facing text
4. Consider save/load compatibility with `on_configuration_changed`
5. Test with both new and existing saves

### When Fixing Bugs
1. Check `factorio-current.log` for error messages
2. Verify prototype names match across data and control stages
3. Ensure `global` table migrations handle all edge cases
4. Test multiplayer compatibility if modifying player-specific data

### When Reviewing Code
1. Verify all prototype names are prefixed to avoid conflicts
2. Check for proper nil handling (Factorio APIs often return nil)
3. Ensure events are properly registered in `on_init` and `on_load`
4. Validate that graphics paths exist and have correct dimensions

### Performance Considerations
- Avoid `on_tick` handlers when possible; use `on_nth_tick` instead
- Cache frequently accessed data in local variables
- Use entity filters in event handlers
- Batch operations when modifying many entities

## Useful Resources

- [Factorio Modding API Documentation](https://lua-api.factorio.com/)
- [Factorio Prototype Documentation](https://wiki.factorio.com/Prototype_definitions)
- [Factorio Modding Forums](https://forums.factorio.com/viewforum.php?f=82)
- [Factorio Mod Portal](https://mods.factorio.com/)

## Git Workflow

- Main development branch: As specified in task context
- Commit messages: Use conventional commits (feat:, fix:, docs:, etc.)
- Test changes locally before pushing
- Update changelog.txt with user-facing changes
