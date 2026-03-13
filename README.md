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
│         │  COMMERCE SCIENCE   │◄─── + Processing Units              │
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

- **Base Rate**: 4 items/second per chest
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
| **Tier 1** | Basic | Iron Gear Wheels, Copper Cable, Pipes, Belts |
| **Tier 2** | Intermediate | Electronic Circuits, Inserters, Splitters |
| **Tier 3** | Advanced | Advanced Circuits, Engine Units, Fast Belts |
| **Tier 4** | High-Tech | Processing Units, Flying Robot Frames, LDS |
| **Tier 5** | End-Game | Rocket Control Units, Satellites, Beacons |

### Size Tiers & Scaling

| Size | Quantity Multiplier | Reward Bonus |
|------|---------------------|--------------|
| **Small** | 1x | 1.0x |
| **Medium** | 5x | 1.2x (+20%) |
| **Large** | 20x | 1.5x (+50%) |
| **Huge** | 100x | 2.0x (+100%) |
| **Massive** | 500x | 3.0x (+200%) |

**Progressive Scaling**: Each time you complete an order for an item type, the next order for that item will be larger with better rewards. This creates natural progression as your factory scales up.

### Example Order Rewards

| Order | Small | Medium | Large | Huge | Massive |
|-------|-------|--------|-------|------|---------|
| 100 Gears | 50 cr | 300 cr | 1,500 cr | 10,000 cr | 75,000 cr |
| 100 Circuits | 200 cr | 1,200 cr | 6,000 cr | 40,000 cr | 300,000 cr |
| 20 Proc Units | 1,000 cr | 6,000 cr | 30,000 cr | 200,000 cr | 1,500,000 cr |

---

## Import Material Progression

Materials are unlocked in tiers. Higher tiers require prerequisites.

```
TIER 0 (Free)           TIER 1 (Unlock)         TIER 2 (Unlock)
─────────────           ───────────────         ───────────────
Iron Ore         ───►   Iron Plate       ───►   Iron Gear Wheel
Copper Ore       ───►   Copper Plate     ───►   Copper Cable
Stone            ───►   Stone Brick             Electronic Circuit
Coal                    Steel Plate              (requires plate + cable)

TIER 3 (Unlock)         TIER 4 (Unlock)
───────────────         ───────────────
Advanced Circuit ───►   Processing Unit
Plastic Bar             Low Density Structure
Sulfur                  Rocket Fuel
Battery
```

---

## Commerce Science & Infinite Research

### Crafting Chain

```
Exchange Data (buy with credits)
       │
       ▼
   ┌───────────────────────────────────┐
   │  2x Exchange Data                 │
   │  5x Electronic Circuit            │──► Data Matrix
   │  10x Copper Cable                 │
   └───────────────────────────────────┘
       │
       ▼
   ┌───────────────────────────────────┐
   │  1x Data Matrix                   │
   │  1x Processing Unit               │──► Commerce Science Pack
   │  2x Advanced Circuit              │
   └───────────────────────────────────┘
```

### Infinite Research Technologies

All bonuses apply **globally** across all your planets!

| Technology | Bonus per Level | Effect |
|------------|-----------------|--------|
| **Assembler Speed** | +2% | Faster crafting on all assemblers |
| **Mining Productivity** | +2% | More ore from every mining operation |
| **Lab Speed** | +2% | Faster research everywhere |
| **Robot Cargo Capacity** | +1 | Robots carry more items |
| **Robot Speed** | +3% | Faster robot movement |
| **Inserter Capacity** | +1 | Higher inserter stack size |

### Cost Formula

Research costs scale with level: `100 × (Level ^ 1.5)` science packs

This creates the classic incremental game progression where early levels are cheap but later levels require significant investment.

---

## Technology Tree

```
Space Science Pack
        │
        ▼
Planet Discovery: The Exchange
        │
        ▼
Trade Protocols I ─────────────────────────────────────┐
(Import/Export Chests)                                 │
        │                                              │
        ▼                                              ▼
Trade Protocols II ◄──────────────────────── Construction Robotics
(Data Terminal, Plate Imports)                         │
        │                                              │
        ▼                                              ▼
Trade Protocols III                          Robot Logistics Bonus
(Data Matrix crafting)                                 │
        │                                              │
        ▼                                              │
Commerce Science ◄─────────────────────────────────────┘
(Science Pack crafting)
        │
        ├──► Assembler Speed I-∞
        ├──► Mining Productivity I-∞
        ├──► Lab Speed I-∞
        ├──► Robot Cargo I-∞ (requires Robot Logistics)
        ├──► Robot Speed I-∞ (requires Robot Logistics)
        └──► Inserter Capacity I-∞
```

---

## Exchange Data Economy

Exchange Data is the **credit sink** that drives the incremental loop.

### Pricing Model

The cost of Exchange Data increases as you purchase more:

| Purchases | Cost per Unit | Cumulative Spent |
|-----------|---------------|------------------|
| 1-10 | 10 cr | 100 cr |
| 11-20 | 15 cr | 250 cr |
| 21-30 | 20 cr | 450 cr |
| 31-40 | 25 cr | 700 cr |
| ... | +50% per tier | Scales infinitely |

**Formula**: `Base Cost × (1 + (Purchases ÷ 10) × 0.5)`

This creates natural pacing - early Commerce Science is cheap, but sustained research requires massive export operations.

---

## GUI Overview

Toggle with the toolbar button or shortcut.

| Tab | Purpose |
|-----|---------|
| **Orders** | View active orders, progress bars, rewards. Reroll for credits. |
| **Upgrades** | Purchase import rate, order slots, and other improvements |
| **Imports** | See available materials by tier |
| **Exchange Data** | Purchase data, view current pricing |
| **Statistics** | Track total earned, spent, orders completed |

---

## Getting Started

1. **Research** "Planet Discovery: The Exchange" (requires Space Science)
2. **Travel** to The Exchange (long journey from Nauvis - beyond Aquilo!)
3. **Bootstrap** using the small native ore patches
4. **Research** "Trade Protocols I" to unlock Import/Export Chests
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
