# 🎲 The Last Dungeon Master

> **The dice have chosen you. The dungeon is waiting.**

**The Last Dungeon Master** is a 2D turn-based fantasy RPG and dungeon crawler inspired by tabletop role-playing games. Players take the role of an inexperienced adventurer who discovers the legendary **Dungeon Master's Dice**, an artifact capable of influencing fate.

Explore dangerous dungeons, fight monsters, discover treasures, interact with mysterious characters, and use dice-based mechanics to determine the outcome of your actions.

---

## 🧙 Game Overview

Long ago, the world was protected by powerful Dungeon Masters who maintained the balance between humans, monsters, and magic.

But the last Dungeon Master disappeared.

Without their guidance, the balance of the world began to collapse. Monsters became more aggressive, ancient dungeons reopened, and forgotten magic returned.

One day, an ordinary adventurer discovers an ancient artifact:

### **The Dungeon Master's Dice**

The dice grant extraordinary power, but they also come with an unpredictable force.

Now, the adventurer must enter the forgotten dungeon, uncover the truth about the missing Dungeon Master, and decide the fate of the world.

---

## 🎮 Genre

* **Genre:** Turn-Based RPG / Dungeon Crawler
* **Perspective:** 2D Top-Down
* **Players:** Single Player
* **Theme:** Fantasy / Adventure
* **Core Mechanic:** Dice-Based Actions
* **Exploration:** Dungeon Rooms
* **Combat:** Turn-Based

---

## ✨ Key Features

### 🎲 Dice-Based Gameplay

The outcome of important actions is determined by a **20-sided die (D20)**.

Different rolls produce different results:

|  Roll | Result           |
| ----: | ---------------- |
|     1 | Critical Failure |
|   2–5 | Failure          |
|  6–10 | Partial Success  |
| 11–15 | Success          |
| 16–19 | Great Success    |
|    20 | Critical Success |

Player statistics, equipment, abilities, and temporary effects can modify the final result.

---

### ⚔️ Turn-Based Combat

Fight monsters using strategic turn-based combat.

During the player's turn, they can:

* ⚔️ Attack
* 🛡️ Defend
* ✨ Use Skills
* 🎒 Use Items
* 🏃 Attempt to Escape

Example:

```text
┌─────────────────────────────┐
│       ⚔️ COMBAT             │
├─────────────────────────────┤
│                             │
│  🧙 Adventurer              │
│  HP: ████████░░ 80/100      │
│                             │
│            VS               │
│                             │
│  👹 Goblin                  │
│  HP: ██████░░░░ 60/100      │
│                             │
├─────────────────────────────┤
│ [⚔️ Attack]  [🛡️ Defend]  │
│ [✨ Skill ]  [🎒 Item  ]   │
└─────────────────────────────┘
```

---

## 🧝 Character Classes

Players can choose from different character classes, each with unique abilities and playstyles.

### ⚔️ Warrior

A powerful melee fighter with high health and defense.

**Strengths:**

* High HP
* High physical damage
* Strong defensive abilities

**Weaknesses:**

* Low magic ability
* Limited ranged attacks

---

### 🗡️ Rogue

A fast and agile fighter specializing in critical attacks and evasion.

**Strengths:**

* High Dexterity
* High critical chance
* Can avoid attacks
* Strong against single targets

**Weaknesses:**

* Low HP
* Lower defense

---

### 🔮 Mage

A powerful spellcaster capable of dealing elemental damage.

**Strengths:**

* High magical damage
* Area-of-effect abilities
* Powerful special skills

**Weaknesses:**

* Low HP
* Low physical defense

---

### ✨ Future Classes

Potential future classes include:

* 🏹 Ranger
* ✝️ Cleric
* 🛡️ Paladin
* 🧙 Warlock

---

## 📊 Character Statistics

Each character has several attributes that affect gameplay.

| Stat             | Description                            |
| ---------------- | -------------------------------------- |
| **Strength**     | Increases physical damage              |
| **Dexterity**    | Affects accuracy, speed, and evasion   |
| **Intelligence** | Increases magical effectiveness        |
| **Constitution** | Increases maximum HP                   |
| **Charisma**     | Influences dialogue and special events |

Character statistics can affect dice rolls.

### Example

```text
Base Roll:        14
Strength Bonus:   +3
Weapon Bonus:     +2
--------------------
Final Result:     19
```

The player achieves a **Great Success**.

---

# 🏰 Dungeon Exploration

The dungeon is divided into interconnected rooms.

Each room can contain different encounters.

```text
        ┌─────────┐
        │ Treasure│
        └────┬────┘
             │
┌─────────┐  │  ┌─────────┐
│  Trap   ├──┼──┤  Battle │
└─────────┘  │  └─────────┘
             │
        ┌────┴────┐
        │  Start  │
        └─────────┘
```

Possible rooms include:

* ⚔️ Combat Room
* 🧰 Treasure Room
* 🧙 NPC Room
* 🧩 Puzzle Room
* 🪤 Trap Room
* 🏕️ Rest Room
* 👹 Boss Room
* 🚪 Secret Room

---

# 👹 Enemies

Players encounter different monsters throughout the dungeon.

### Example Enemies

| Enemy             | Difficulty | Description                   |
| ----------------- | ---------- | ----------------------------- |
| 🧟 Skeleton       | Easy       | Basic melee enemy             |
| 👺 Goblin         | Easy       | Fast but weak                 |
| 🕷️ Giant Spider  | Medium     | Uses poison                   |
| 👻 Wraith         | Medium     | Resistant to physical attacks |
| 🧌 Ogre           | Hard       | Slow but extremely powerful   |
| 🐉 Ancient Dragon | Boss       | Final dungeon boss            |

Each enemy has unique:

* HP
* Attack
* Defense
* Skills
* Resistances
* AI behavior

---

# 🎒 Items & Equipment

Players can discover equipment and items throughout the dungeon.

### Weapons

* Iron Sword
* Steel Axe
* Shadow Dagger
* Arcane Staff
* Legendary Blade

### Armor

* Leather Armor
* Iron Armor
* Mage Robe
* Shadow Cloak
* Ancient Armor

### Consumables

* ❤️ Health Potion
* 💙 Mana Potion
* 🧪 Antidote
* 🎲 Fate Token

---

# 🎲 Fate System

The **Fate System** is the main gameplay mechanic.

Players can sometimes influence the result of a dice roll.

### Fate Tokens

Fate Tokens allow the player to:

* Reroll a failed result
* Add a bonus to a roll
* Increase critical chance
* Alter certain story events

However, Fate Tokens are limited.

The player must decide when a roll is worth changing.

---

## Example

The player encounters a locked door.

```text
🔒 Ancient Door

[Open the door]

🎲 Rolling...

Result: 4

CRITICAL FAILURE
```

The player can use a Fate Token:

```text
Use Fate Token?

[YES]   [NO]
```

New roll:

```text
🎲 17

GREAT SUCCESS
```

The door opens.

But using the token means fewer resources are available for future encounters.

---

# 🧩 Events & Choices

Not every encounter requires combat.

Players may encounter NPCs, puzzles, traps, and unexpected events.

For example:

```text
You discover a wounded traveler.

He asks for your help.

[1] Give him a Health Potion
[2] Ignore him
[3] Ask what happened
[4] Threaten him
```

Your choice can affect:

* Reputation
* Future encounters
* Available quests
* NPC relationships
* Dungeon events
* Story endings

---

# 💀 Death & Consequences

Death is part of the adventure.

If the player's HP reaches zero:

```text
        💀
   YOU HAVE FALLEN

The dungeon remembers
your failure.

[Restart]
[Return to Main Menu]
```

Depending on the game mode, the player may lose:

* Gold
* Items
* Progress
* Temporary buffs

Some decisions can permanently affect future runs.

---

# 🏆 Boss Battles

Each major dungeon ends with a unique boss encounter.

Bosses have multiple phases.

Example:

```text
              🐉
        ANCIENT GUARDIAN

        HP: ██████████
            1000 / 1000

Phase 1
↓
Normal attacks

Phase 2
↓
New abilities unlocked

Phase 3
↓
Enraged state
```

Boss mechanics require the player to understand enemy patterns and manage their resources.

---

# 📖 Story Progression

The player gradually discovers what happened to the last Dungeon Master.

The story is divided into chapters.

### Chapter 1 — The Forgotten Dungeon

The player discovers the Dungeon Master's Dice.

### Chapter 2 — Echoes of the Past

The player learns about the Dungeon Masters.

### Chapter 3 — The Broken Balance

Monsters begin escaping from the dungeon.

### Chapter 4 — The Final Trial

The player reaches the deepest part of the dungeon.

### Chapter 5 — The Last Roll

The player must decide what to do with the Dungeon Master's Dice.

---

# 🌎 Possible Endings

The player's decisions determine the final outcome.

Possible endings include:

### 🛡️ Restore the Balance

The player uses the Dice to restore the world's balance.

### 👑 Become the New Dungeon Master

The player accepts the responsibility of controlling the dungeon.

### 💀 Destroy the Dice

The player destroys the artifact and ends the Dungeon Master's power.

### 🌑 Break the Rules

The player uses the Dice to rewrite the rules of the world.

---

# 🕹️ Core Gameplay Loop

```text
        ┌───────────────┐
        │     START     │
        └───────┬───────┘
                ↓
        ┌───────────────┐
        │ Explore       │
        │ Dungeon       │
        └───────┬───────┘
                ↓
        ┌───────────────┐
        │ Encounter     │
        │ Event         │
        └───────┬───────┘
                ↓
       ┌────────┴────────┐
       ↓                 ↓
    Combat             Event
       ↓                 ↓
       └────────┬────────┘
                ↓
        ┌───────────────┐
        │ Gain XP /     │
        │ Items / Gold  │
        └───────┬───────┘
                ↓
        ┌───────────────┐
        │ Character     │
        │ Progression   │
        └───────┬───────┘
                ↓
        ┌───────────────┐
        │ Next Room     │
        └───────┬───────┘
                ↓
             Boss?
             /   \
           No     Yes
           │       │
           └───┐   ↓
               │  Ending
               ↓
             Continue
```

---

# 🛠️ Technology

The technology stack can be changed depending on the development requirements.

### Recommended

* **Game Engine:** Godot
* **Language:** GDScript
* **Graphics:** 2D Pixel Art
* **Audio:** Free/Open-source fantasy sound effects and music
* **Version Control:** Git + GitHub

### Alternative

* Unity + C#
* Unreal Engine
* Phaser + TypeScript

---

# 📁 Project Structure

Example Godot project structure:

```text
The-Last-Dungeon-Master/
│
├── assets/
│   ├── characters/
│   ├── enemies/
│   ├── environments/
│   ├── items/
│   ├── ui/
│   ├── audio/
│   └── fonts/
│
├── scenes/
│   ├── main/
│   ├── character/
│   ├── dungeon/
│   ├── combat/
│   ├── enemies/
│   ├── ui/
│   └── bosses/
│
├── scripts/
│   ├── player/
│   ├── combat/
│   ├── dungeon/
│   ├── enemies/
│   ├── inventory/
│   ├── dialogue/
│   └── systems/
│
├── data/
│   ├── characters/
│   ├── enemies/
│   ├── items/
│   └── skills/
│
├── README.md
└── project.godot
```

---

# 🚀 Development Roadmap

## Phase 1 — Prototype

* [ ] Main menu
* [ ] Player movement
* [ ] Basic dungeon room
* [ ] D20 dice system
* [ ] Basic enemy
* [ ] Basic combat

## Phase 2 — Core Systems

* [ ] Character classes
* [ ] Character statistics
* [ ] Skills
* [ ] Inventory
* [ ] Equipment
* [ ] Experience and leveling
* [ ] Multiple enemies

## Phase 3 — Dungeon

* [ ] Multiple rooms
* [ ] Treasure rooms
* [ ] Trap rooms
* [ ] NPC rooms
* [ ] Random encounters
* [ ] Dungeon generation

## Phase 4 — Story

* [ ] Dialogue system
* [ ] Quests
* [ ] Story events
* [ ] Player choices
* [ ] Multiple endings

## Phase 5 — Boss & Polish

* [ ] Boss battles
* [ ] Boss phases
* [ ] Sound effects
* [ ] Background music
* [ ] Visual effects
* [ ] UI improvements
* [ ] Save/load system

---

# 🎯 Minimum Viable Product (MVP)

The first playable version should contain:

* [x] One playable character
* [x] One character class
* [x] One dungeon
* [x] 5–10 rooms
* [x] 3 enemy types
* [x] D20 combat
* [x] Basic inventory
* [x] Basic equipment
* [x] One boss
* [x] One ending

Additional content can be added after the core gameplay is stable.

---

# 🎨 Art Direction

The game uses a **dark fantasy pixel-art style**.

### Visual inspirations

* Forgotten medieval ruins
* Ancient magical temples
* Underground caves
* Haunted castles
* Forgotten libraries
* Magical artifacts

The UI should combine traditional fantasy elements with a clean modern interface.

### Color Concept

```text
Dungeon
████ Dark stone

Magic
████ Arcane glow

UI
████ Ancient parchment

Danger
████ Crimson accents
```

---

# 🎵 Audio Direction

The soundtrack should change depending on the situation.

| Situation           | Audio Style           |
| ------------------- | --------------------- |
| Dungeon Exploration | Atmospheric fantasy   |
| Combat              | Fast-paced orchestral |
| Boss                | Dark and intense      |
| Town                | Calm medieval         |
| Treasure            | Magical / mysterious  |
| Story               | Emotional ambient     |

---

# 🔮 Future Features

Possible future updates include:

* Procedurally generated dungeons
* More character classes
* More bosses
* Random quests
* NPC relationship system
* New game+
* Character customization
* Achievement system
* Difficulty modes
* Challenge mode
* Multiplayer tabletop mode
* Dungeon Master mode

---

# 📜 License

This project is an original fantasy RPG project inspired by tabletop role-playing game mechanics.

All original code, artwork, characters, story, and assets created for this project belong to the project contributors unless otherwise stated.

Third-party assets and libraries remain under their respective licenses.

---

# 👥 Development Team

**The Last Dungeon Master**

A fantasy RPG project focused on combining traditional dungeon-crawling gameplay with a dynamic dice-based decision system.

> **Every room has a story.
> Every choice has a consequence.
> Every roll can change your fate.**

🎲 **Roll the dice. Enter the dungeon. Change your fate.**
