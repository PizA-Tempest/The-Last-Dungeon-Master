# AGENTS.md — The Last Dungeon Master

> Bootstrapped Godot 4.7 project (targets **4.7.2-stable**, GL Compatibility). No CI, no tests, no `opencode.json`. Verified headless 2026-09-17 with `4.7.2.stable.official.ed1daf0bf` (winget `GodotEngine.GodotEngine` 4.7.2; console exe `Godot_v4.7.2-stable_win64_console.exe`).

## Stack

- **Godot 4.7.2-stable + GDScript**, 2D top-down pixel art. `project.godot` exists; main scene is the menu `scenes/ui/main_menu.tscn`, game scene `scenes/main/main.tscn` (script `scripts/main.gd`).
- Verify (no SCRIPT ERROR in either): menu `godot --headless --path . --quit` prints `Main menu ready…`; game `godot --headless --path . res://scenes/main/main.tscn --quit` prints `The Last Dungeon Master booted. D20=…`.
- `godot` may not be on PATH (winget without admin skips aliases) — use the full path to `Godot_v4.7.2-stable_win64_console.exe` under `%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_*`. Players just double-click `run_game.bat` (finds the exe, runs `--path .`).
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
- Systems layer is pure `RefCounted` (`scripts/systems/dice_roller.gd`, `fate_system.gd`, `xp_system.gd`): `DiceRoller.resolve(base, stat, equip)` is the deterministic entry for tests/rerolls; pass in `RandomNumberGenerator` for real rolls. Content data lives in `data/*.json` (warrior/rogue/mage, goblin/skeleton).
- Phase 2 start: player loads class stats from `data/characters/<class_id>.json` (`_load_class`, tolerant of missing files); kills award `xp_for_kill` XP via `main._on_enemy_died` → `player.add_xp` (level = +20 HP full-heal, +1 STR); T (`use_fate`) spends a Fate Token to reroll the last miss with no extra retaliation. `enemy.gd` has `body_color`/`dark_color` exports (pale Skeleton + Brute in main scene).
- Phase 1 prototype: `scenes/character/player.tscn` (`CharacterBody2D`, speed 200, `scripts/player/player.gd`) moves with custom `move_*` actions and attacks with `attack` (all bound by physical keycode in `project.godot` `[input]` — arrows + WASD, Space/Enter — never the `ui_*` defaults, which vary); `scenes/dungeon/room.tscn` is the floor + 4 `StaticBody2D` walls, both instanced in `scenes/main/main.tscn`.
- Combat is turn-exchange, not real-time: Space/Enter (`ui_accept`) or left-click hits nearest enemy in range via deterministic `scripts/combat/melee.gd` (`resolve_player_attack` / `resolve_enemy_attack`, verified with a throwaway SceneTree check); enemy (`scripts/enemies/enemy.gd`, `take_damage()` returns killed, emits `died`) retaliates immediately. Attack input must live in `_unhandled_input` — `is_action_just_pressed()` in `_physics_process` drops presses. HUD controls use `mouse_filter = IGNORE` so clicks reach the game. Player HP 100, HUD in `scenes/ui/hud.tscn`. UI scripts colocate with their scenes under `scenes/ui/` (no `scripts/ui/`).
- Game loop: kill all enemies → VictoryPanel, player death → DeathPanel (`scripts/main.gd`, either Restart reloads the scene). Juice via `main.spawn_popup()` damage numbers and `main.shake()` camera offset. Main scene holds 3 goblins + 1 Brute (stat/scale overrides on the instance).
- Shared UI theme in `assets/ui/theme.tres` (SystemFont stack + gold-on-stone Button / PanelContainer card styles) — menu, end panels, and HUD all use it; end panels are `PanelContainer` cards over a dim layer. Dead player can't act (`try_attack` guards `hp <= 0`, physics off) and enemies idle when player HP is 0.
- All art is procedural `_draw()` (no textures yet): room tiles/torches/banners in `scripts/dungeon/room.gd` (Room node needs `_process` + `queue_redraw` for torch flicker), goblin face + HP bar in `enemy.gd`, adventurer + sword + slash arc in `player.gd`. Note: `PackedVector2Array([...])` needs the array literal — varargs constructor does not exist.
- No test/build commands exist yet — do not claim any. When adding a runnable project, document the exact Godot version and headless verify command in this file.
