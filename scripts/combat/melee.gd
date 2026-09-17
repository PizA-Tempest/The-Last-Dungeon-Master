class_name Melee
extends RefCounted
## Basic combat math (Phase 1). Pure logic — deterministic entry points
## for tests, same pattern as DiceRoller. Thresholds mirror the D20 tiers:
## 1 = crit fail, 2-5 = fail, 6-10 = partial, 11-15 = success,
## 16-19 = great, 20 = crit.
## Player power = 4 + STR bonus + weapon bonus (Warrior example: 4+3+2 = 9,
## minus Goblin defense 2 = 7 on a Success).


static func player_power(str_bonus: int, weapon_bonus: int) -> int:
	return 4 + str_bonus + weapon_bonus


## Returns {"base", "name", "damage", "self_hit"}.
static func resolve_player_attack(base_roll: int, str_bonus: int, weapon_bonus: int, enemy_defense: int) -> Dictionary:
	var full: int = maxi(1, player_power(str_bonus, weapon_bonus) - enemy_defense)
	if base_roll <= 1:
		return {"base": base_roll, "name": "Critical Failure", "damage": 0, "self_hit": 1}
	if base_roll <= 5:
		return {"base": base_roll, "name": "Failure", "damage": 0, "self_hit": 0}
	if base_roll <= 10:
		return {"base": base_roll, "name": "Partial Success", "damage": maxi(1, full / 2), "self_hit": 0}
	if base_roll <= 15:
		return {"base": base_roll, "name": "Success", "damage": full, "self_hit": 0}
	if base_roll <= 19:
		return {"base": base_roll, "name": "Great Success", "damage": full + 2, "self_hit": 0}
	return {"base": base_roll, "name": "Critical Success", "damage": full * 2, "self_hit": 0}


## Enemy retaliation: hits on 11+, harder on 16+, brutal on 20.
## Returns {"base", "damage"} (damage 0 = miss).
static func resolve_enemy_attack(base_roll: int, enemy_attack: int) -> Dictionary:
	if base_roll <= 10:
		return {"base": base_roll, "damage": 0}
	if base_roll <= 15:
		return {"base": base_roll, "damage": enemy_attack}
	if base_roll <= 19:
		return {"base": base_roll, "damage": enemy_attack + 2}
	return {"base": base_roll, "damage": enemy_attack * 2}
