# The Exchange

A new planet mod for Factorio Space Age. Journey to **The Exchange**, an ancient megastructure beyond Aquilo, where you import materials, fulfill orders, earn credits, and unlock permanent factory-wide bonuses through Commerce Science research.

---

## The Exchange - Lore & Setting

> *"An ancient megastructure from a forgotten civilization, drifting in the outer reaches of the system. Its automated life support maintains perfect conditions while ambient energy harvesters collect cosmic radiation, enabling exceptional solar power efficiency. The trading protocols remain active, waiting for new partners."*

The Exchange is not a natural planet - it's a massive **space station** or **megastructure** built by a long-gone civilization. Despite its location beyond Aquilo in the frozen outer reaches of the solar system, the station's ancient systems maintain perfect conditions:

| Property | Value | Explanation |
|----------|-------|-------------|
| **Location** | Beyond Aquilo | Furthest destination in the system |
| **Solar Efficiency** | 200% surface / 300% space | Ambient energy harvesters boost power collection |
| **Temperature** | Habitable | Ancient life support - no heating required |
| **Day/Night Cycle** | None (always day) | Artificial lighting systems |
| **Hazards** | None | Focus purely on building and optimization |
| **Drop Pod Restrictions** | None | Bring your legendary gear! |

---

## Core Gameplay Loop

```
┌─────────────────────────────────────────────────────────────────────┐
│                     THE EXCHANGE ECONOMY                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   IMPORT CHESTS              FACTORY                 EXPORT CHESTS  │
│   ─────────────              ───────                 ─────────────  │
│   Iron Ore ─────┐                              ┌───► Gears          │
│   Copper Ore ───┼──► Smelting ──► Assembly ───┼───► Circuits       │
│   Coal ─────────┘                              └───► Engines        │
│        │                                                  │         │
│        │ (free)                                (orders)   │         │
│        ▼                                                  ▼         │
│   ┌─────────┐                                      ┌──────────┐     │
│   │ IMPORTS │                                      │ CREDITS  │     │
│   └─────────┘                                      └────┬─────┘     │
│                                                         │           │
│                    ┌────────────────────────────────────┘           │
│                    │                                                │
│                    ▼                                                │
│         ┌─────────────────────┐                                     │
│         │   EXCHANGE DATA     │◄─── Purchase with credits           │
│         │   (credit sink)     │     (scaling cost)                  │
│         └──────────┬──────────┘                                     │
│                    │                                                │
│                    ▼                                                │
│         ┌─────────────────────┐                                     │
│         │    DATA MATRIX      │◄─── + Electronic Circuits           │
│         └──────────┬──────────┘                                     │
│                    │                                                │
│                    ▼                                                │
│         ┌─────────────────────┐                                     │
│         │  COMMERCE SCIENCE   │◄─── + Advanced Circuits             │
│         │       PACK          │                                     │
│         └──────────┬──────────┘                                     │
│                    │                                                │
│                    ▼                                                │
│         ┌─────────────────────┐                                     │
│         │  INFINITE RESEARCH  │──► Global bonuses for ALL planets   │
│         └─────────────────────┘                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Entities

### Import Chest (Blue Tint)
Generates resources automatically and outputs them to adjacent belts.

- **Base Rate**: 2 items/second per chest (1 item every 30 ticks)
- **Upgradeable**: Import rate can be increased via upgrades
- **Material Tiers**: Progress from ores → plates → intermediates
- **No Inserters Needed**: Items flow directly to belts

### Export Chest (Orange Tint)
Accepts products from belts to fulfill active orders.

- **Automatic Matching**: Items are matched against active orders
- **Credit Rewards**: Matching items are consumed and credits awarded
- **Progress Tracking**: GUI shows real-time order completion

### Data Terminal (Purple Tint)
Converts credits into Exchange Data.

- **Auto-Purchase Mode**: Continuously buys Exchange Data when enabled
- **Scaling Cost**: Price increases as you purchase more (incremental game style)
- **Output Buffer**: Small inventory for collecting purchased data

---

## Order System

Orders are the primary way to earn credits. Complete orders to unlock larger versions with better rewards.

### Complexity Tiers

| Tier | Products | Examples |
|------|----------|----------|
| **Tier 1** | Basic | Iron Plates, Copper Plates, Iron Gear Wheels, Stone Bricks |
| **Tier 2** | Intermediate | Electronic Circuits, Steel Plates, Transport Belts |
| **Tier 3** | Advanced | Advanced Circuits, Engine Units, Batteries, Fast Inserters |
| **Tier 4** | High-Tech | Processing Units, Flying Robot Frames, LDS, Rocket Fuel |
| **Tier 5** | End-Game | Rocket Control Units, Modules, Solar Panels, Accumulators |

### Size Tiers & Scaling

| Size | Quantity Multiplier | Reward Bonus |
|------|---------------------|--------------|
| **Small** | 1x | 1.0x |
| **Medium** | 2.5x | 1.2x (+20%) |
| **Large** | 5x | 1.5x (+50%) |
| **Huge** | 10x | 2.0x (+100%) |
| **Massive** | 25x | 3.0x (+200%) |

**Progressive Scaling**: Each time you complete an order for an item type, the next order for that item will be 10% larger. Rewards scale proportionally, creating natural progression as your factory scales up.

### Example Order Rewards (Base, before progression scaling)

| Order | Small | Medium | Large | Huge | Massive |
|-------|-------|--------|-------|------|---------|
| Gears (base 50) | 150 cr | 450 cr | 1,125 cr | 3,000 cr | 11,250 cr |
| E-Circuits (base 50) | 250 cr | 750 cr | 1,875 cr | 5,000 cr | 18,750 cr |
| Proc Units (base 10) | 500 cr | 1,500 cr | 3,750 cr | 10,000 cr | 37,500 cr |

---

## Import Material Progression

Materials are unlocked in tiers via research and credit purchases.

```
TIER 1 (Free)           TIER 2 (Research)       TIER 3 (Research + Credits)
─────────────           ────────────────        ───────────────────────────
Iron Ore                Iron Plate              Iron Gear Wheel
Copper Ore              Copper Plate            Copper Cable
Stone                   Steel Plate             Electronic Circuit
Coal                    Stone Brick             Pipe
Wood

TIER 4 (Research + Credits)    TIER 5 (Research + Credits)
──────────────────────────     ──────────────────────────
Advanced Circuit               Processing Unit
Plastic Bar                    Electric Engine Unit
Sulfur                         Low Density Structure
Battery                        Rocket Fuel
Engine Unit
```

Tier 2 imports are auto-unlocked when researching Advanced Orders. Tiers 3-5 require both the matching research AND a one-time credit purchase per material (300-15,000 credits).

---

## Commerce Science & Infinite Research

### Crafting Chain

```
Exchange Data (buy with credits at Data Terminal)
       │
       ▼
   ┌───────────────────────────────────┐
   │  5x Exchange Data                 │
   │  2x Electronic Circuit            │──► Data Matrix (5 sec)
   │  1x Iron Plate                    │
   └───────────────────────────────────┘
       │
       ▼
   ┌───────────────────────────────────┐
   │  3x Data Matrix                   │
   │  1x Advanced Circuit              │──► Commerce Science Pack (10 sec)
   │  10x Copper Cable                 │
   └───────────────────────────────────┘
```

### Infinite Research Technologies

All bonuses apply **globally** across all your planets!

| Technology | Bonus per Level | Base Cost | Effect |
|------------|-----------------|-----------|--------|
| **Crafting Speed** | +5% | 100 packs | Faster hand-crafting speed |
| **Mining Productivity** | +2% | 150 packs | More ore from mining drills |
| **Lab Speed** | +5% | 100 packs | Faster research everywhere |
| **Robot Cargo Capacity** | +1 | 200 packs | Robots carry more items |
| **Robot Speed** | +5% | 200 packs | Faster robot movement |
| **Inserter Capacity** | +1 | 150 packs | Higher inserter stack size |

### Cost Formula

Research costs scale with level: `Base × (Level ^ 1.5)` science packs

Each infinite research requires Commerce Science Packs plus one additional science type (Production or Utility). Robot and Inserter technologies require their vanilla research chain to be completed first.

---

## Technology Tree

```
Space Science Pack
        │
        ▼
Planet Discovery: The Exchange ─────────► (unlocks travel)
        │
        ▼
Incremental Commerce ──────────────────► Advanced Orders (Tier 2)
(Import/Export Chests)                          │
        │                                       ▼
        ▼                                Complex Orders (Tier 3)
Data Terminal ◄── Advanced Circuits            │
(Data Terminal + Data Matrix)                   ▼
        │                              Industrial Orders (Tier 4)
        ▼                                       │
Commerce Science ◄── Production Science         ▼
(Commerce Science Pack)                  Mega Orders (Tier 5)
        │
        ├──► Crafting Speed I-∞
        ├──► Mining Productivity I-∞
        ├──► Lab Speed I-∞
        ├──► Robot Cargo I-∞ (requires Worker Robot Storage 3)
        ├──► Robot Speed I-∞ (requires Worker Robot Speed 6)
        └──► Inserter Capacity I-∞ (requires Inserter Capacity 7)
```

---

## Exchange Data Economy

Exchange Data is the **credit sink** that drives the incremental loop.

### Pricing Model

The cost of Exchange Data increases exponentially as you purchase more:

| Purchase # | Cost per Unit |
|------------|---------------|
| 1st | 100 cr |
| 10th | 119 cr |
| 50th | 263 cr |
| 100th | 692 cr |
| 200th | 4,799 cr |
| 500th | 1,926,440 cr |

**Formula**: `floor(Base Cost × 1.02^purchases)`

The default base cost is 100 credits with 2% scaling per purchase (configurable in mod settings). The Data Conversion Efficiency upgrade reduces costs multiplicatively.

This creates natural pacing - early Commerce Science is affordable, but sustained research requires progressively larger export operations.

---

## GUI Overview

Toggle with the toolbar button or shortcut.

| Tab | Purpose |
|-----|---------|
| **Orders** | View active orders, progress bars, rewards. Reroll for credits. |
| **Upgrades** | Purchase import rate, order slots, reward bonus, and data conversion efficiency |
| **Imports** | See available materials by tier |
| **Exchange Data** | Purchase data, view current pricing |
| **Statistics** | Track total earned, spent, orders completed |

---

## Getting Started

1. **Research** "Planet Discovery: The Exchange" (requires Space Science)
2. **Travel** to The Exchange (long journey from Nauvis - beyond Aquilo!)
3. **Bootstrap** using the small native ore patches
4. **Research** "Incremental Commerce" to unlock Import/Export Chests
5. **Build** Import Chests and select materials to generate
6. **Process** raw materials into products
7. **Export** via Export Chests to fulfill orders
8. **Earn credits** and purchase Exchange Data
9. **Research** Commerce Science for infinite global bonuses
10. **Return** periodically to scale up and continue progression!

---

## Installation

### Requirements
- Factorio 2.0+
- Space Age DLC

### Install Location
Copy the mod folder to your Factorio mods directory:

| Platform | Path |
|----------|------|
| Windows | `%APPDATA%\Factorio\mods\the-exchange` |
| Linux | `~/.factorio/mods/the-exchange` |
| macOS | `~/Library/Application Support/factorio/mods/the-exchange` |

---

## Console Commands (Testing)

```lua
-- Add credits
/c remote.call("the-exchange", "add_credits", 10000)

-- View current credits
/c game.print(remote.call("the-exchange", "get_credits"))

-- View active orders
/c game.print(serpent.block(remote.call("the-exchange", "get_active_orders")))

-- View statistics
/c game.print(serpent.block(remote.call("the-exchange", "get_statistics")))
```

---

## License

MIT License

## Contributing

Contributions welcome! Please open an issue or pull request on GitHub.
