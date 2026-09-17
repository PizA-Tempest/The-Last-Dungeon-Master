# AGENTS.md — The Last Dungeon Master

> Bootstrapped Godot 4.7 project (targets **4.7.2-stable**, GL Compatibility). No CI, no tests, no `opencode.json`. Verified headless 2026-09-17 with `4.7.2.stable.official.ed1daf0bf` (winget `GodotEngine.GodotEngine` 4.7.2; console exe `Godot_v4.7.2-stable_win64_console.exe`).

## Stack

- **Godot 4.7.2-stable + GDScript**, 2D top-down pixel art. `project.godot` exists; main scene `scenes/main/main.tscn` (script `scripts/main.gd`).
- Verify: `godot --headless --path . --quit` — must print `The Last Dungeon Master booted. D20=…` with no SCRIPT ERROR. Same command covers import + boot check.
- `godot` may not be on PATH (winget without admin skips aliases) — use the full path to `Godot_v4.7.2-stable_win64_console.exe` under `%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_*`.
- Cross-script refs must use `preload("res://…")`, not bare global class names: fresh checkouts fail boot otherwise (global class cache is only built by the editor import).

## Canonical rules (do not reinvent — from README)

- Core mechanic is **D20**: 1 = Critical Failure, 2–5 = Failure, 6–10 = Partial Success, 11–15 = Success, 16–19 = Great Success, 20 = Critical Success.
- Rolls are modified: `final = base roll + stat bonus + equipment bonus` (e.g. 14 + 3 STR + 2 weapon = 19, Great Success).
- Stats: Strength (phys dmg), Dexterity (accuracy/speed/evasion), Intelligence (magic), Constitution (max HP), Charisma (dialogue/events).
- Fate Tokens (limited resource) can: reroll, add bonus, boost crit chance, alter story events.
- Planned room types: Combat, Treasure, NPC, Puzzle, Trap, Rest, Boss, Secret. Enemy roster and 5-chapter story are defined in `README.md` — consult it before adding content.

## Working conventions

- `README.md` is the executable source of truth for design until code exists. If a request conflicts with it, flag it and follow the request.
- Target structure for new files (from README): `assets/`, `scenes/{main,character,dungeon,combat,enemies,ui,bosses}/`, `scripts/{player,combat,dungeon,enemies,inventory,dialogue,systems}/`, `data/{characters,enemies,items,skills}/`.
- GDScript style once code exists: default Godot conventions (snake_case, `class_name` only where needed); keep dice/combat math in `scripts/systems/` so it is testable, not embedded in scenes.
- Systems layer is pure `RefCounted` (`scripts/systems/dice_roller.gd`, `fate_system.gd`): `DiceRoller.resolve(base, stat, equip)` is the deterministic entry for tests/rerolls; pass in `RandomNumberGenerator` for real rolls. Content data lives in `data/*.json` (one example each: warrior, goblin).
- Phase 1 prototype: `scenes/character/player.tscn` (`CharacterBody2D`, speed 200, `scripts/player/player.gd`) moves with built-in `ui_*` actions (arrows/WASD, no custom InputMap); `scenes/dungeon/room.tscn` is the floor + 4 `StaticBody2D` walls, both instanced in `scenes/main/main.tscn`.
- No test/build commands exist yet — do not claim any. When adding a runnable project, document the exact Godot version and headless verify command in this file.
