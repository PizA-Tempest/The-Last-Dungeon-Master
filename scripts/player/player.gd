extends CharacterBody2D
## Top-down player movement (Phase 1 prototype).
## Uses built-in ui_left/ui_right/ui_up/ui_down actions (arrows + WASD
## by default) so no custom InputMap setup is required.

@export var speed := 200.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
