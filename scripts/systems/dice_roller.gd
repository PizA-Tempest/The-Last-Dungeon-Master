class_name DiceRoller
extends RefCounted
## Canonical D20 system — see README.md / AGENTS.md.
## Keep pure (no scene-tree access) so logic stays testable.
## Final = base roll + stat bonus + equipment bonus. Classify on the
## *base* d20 per design doc tiers, unless house-ruled otherwise.

enum RollResult {
	CRITICAL_FAILURE,
	FAILURE,
	PARTIAL_SUCCESS,
	SUCCESS,
	GREAT_SUCCESS,
	CRITICAL_SUCCESS,
}

const SIDES := 20


static func classify(base_roll: int) -> RollResult:
	if base_roll <= 1:
		return RollResult.CRITICAL_FAILURE
	if base_roll <= 5:
		return RollResult.FAILURE
	if base_roll <= 10:
		return RollResult.PARTIAL_SUCCESS
	if base_roll <= 15:
		return RollResult.SUCCESS
	if base_roll <= 19:
		return RollResult.GREAT_SUCCESS
	return RollResult.CRITICAL_SUCCESS


static func apply_modifiers(base_roll: int, stat_bonus: int = 0, equipment_bonus: int = 0) -> int:
	return base_roll + stat_bonus + equipment_bonus


static func roll(rng: RandomNumberGenerator, stat_bonus: int = 0, equipment_bonus: int = 0) -> Dictionary:
	var base_roll: int = rng.randi_range(1, SIDES)
	return resolve(base_roll, stat_bonus, equipment_bonus)


## Deterministic entry point — use for tests and Fate Token rerolls.
static func resolve(base_roll: int, stat_bonus: int = 0, equipment_bonus: int = 0) -> Dictionary:
	var final_value: int = apply_modifiers(base_roll, stat_bonus, equipment_bonus)
	return {
		"base": base_roll,
		"final": final_value,
		"result": classify(base_roll),
	}


static func result_name(result: RollResult) -> String:
	match result:
		RollResult.CRITICAL_FAILURE:
			return "Critical Failure"
		RollResult.FAILURE:
			return "Failure"
		RollResult.PARTIAL_SUCCESS:
			return "Partial Success"
		RollResult.SUCCESS:
			return "Success"
		RollResult.GREAT_SUCCESS:
			return "Great Success"
		RollResult.CRITICAL_SUCCESS:
			return "Critical Success"
	return "Unknown"
