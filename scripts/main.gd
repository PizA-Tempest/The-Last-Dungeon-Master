extends Node2D
## Bootstrap scene: proves project loads. Phase 1 prototype starts here.
## Uses preload (not the global class name) so a fresh checkout boots
## on the first `godot --headless --path .` run, before the editor has
## built the global class cache.

const DiceRollerScript := preload("res://scripts/systems/dice_roller.gd")

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	var outcome: Dictionary = DiceRollerScript.roll(_rng, 3, 2)
	print("The Last Dungeon Master booted. D20=%d final=%d (%s)" % [
		outcome["base"],
		outcome["final"],
		DiceRollerScript.result_name(outcome["result"]),
	])
