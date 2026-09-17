class_name FateSystem
extends RefCounted
## Fate Tokens: limited reroll / bonus resource. Pure logic, no autoload needed.

enum FateUse {
	REROLL,
	ADD_BONUS,
	BOOST_CRIT,
	ALTER_STORY,
}


const DiceRollerScript := preload("res://scripts/systems/dice_roller.gd")

static func can_spend(tokens: int, cost: int = 1) -> bool:
	return tokens >= cost


## Returns new token count after spending, or -1 if unaffordable.
static func spend(tokens: int, cost: int = 1) -> int:
	if not can_spend(tokens, cost):
		return -1
	return tokens - cost


## Reroll helper: caller provides the new base roll (from DiceRoller),
## this just validates the spend. Returns {"tokens": int, "roll": Dictionary}.
static func reroll(tokens: int, new_base_roll: int, stat_bonus: int = 0, equipment_bonus: int = 0) -> Dictionary:
	var remaining: int = spend(tokens, 1)
	if remaining < 0:
		return {"tokens": tokens, "roll": {}, "ok": false}
	return {"tokens": remaining, "roll": DiceRollerScript.resolve(new_base_roll, stat_bonus, equipment_bonus), "ok": true}
