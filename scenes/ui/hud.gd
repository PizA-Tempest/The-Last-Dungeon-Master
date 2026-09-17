extends Control
## Combat HUD (Phase 1): player HP readout + last combat message.
## Player finds it via the "hud" group; all calls are null-guarded.


func _ready() -> void:
	add_to_group("hud")


func set_hp(current: int, maximum: int) -> void:
	$Top/HpLabel.text = "HP: %d/%d" % [current, maximum]
	($Top/HpBar as ProgressBar).max_value = maximum
	($Top/HpBar as ProgressBar).value = current


func log(text: String) -> void:
	$Bottom/LogLabel.text = text
