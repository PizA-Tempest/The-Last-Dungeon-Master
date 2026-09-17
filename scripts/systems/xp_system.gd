class_name XpSystem
extends RefCounted
## XP + leveling math (Phase 2). Pure logic — deterministic, testable.
## Curve: reaching level N+1 costs 100 * N XP (L1->L2 = 100).
## Kill XP = half the enemy's max HP (Goblin 60 -> 30).
## Each level: +20 max HP (and full heal), +1 Strength.


static func xp_needed(level: int) -> int:
	return 100 * level


static func level_bonuses() -> Dictionary:
	return {"max_hp": 20, "strength": 1}


static func xp_for_kill(enemy_max_hp: int) -> int:
	return maxi(1, enemy_max_hp / 2)
