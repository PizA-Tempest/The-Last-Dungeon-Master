extends CharacterBody2D
## Basic enemy (Phase 1): chases the player in aggro range, takes
## D20-based hits via take_damage(), emits `died` at 0 HP. Stats mirror
## data/enemies/goblin.json (HP 60, attack 8, defense 2). Visuals (goblin
## face + HP bar) are drawn procedurally in _draw().

signal died(enemy: Node)

@export var enemy_name := "Goblin"
@export var max_hp := 60
@export var attack := 8
@export var defense := 2
@export var chase_speed := 60.0
@export var aggro_range := 280.0
@export var keep_distance := 40.0
@export var body_color := Color(0.32, 0.66, 0.30)
@export var dark_color := Color(0.22, 0.50, 0.22)

var hp: int
var _player: Node2D
var _base_scale := Vector2.ONE


func _ready() -> void:
	add_to_group("enemies")
	hp = max_hp
	_base_scale = scale
	queue_redraw()


func _physics_process(_delta: float) -> void:
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player") as Node2D
		if _player == null:
			return
	if int(_player.get("hp")) <= 0:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var to_player: Vector2 = _player.global_position - global_position
	if to_player.length() < aggro_range and to_player.length() > keep_distance:
		velocity = to_player.normalized() * chase_speed
	else:
		velocity = Vector2.ZERO
	velocity += _separation() * 3.0
	move_and_slide()


## Returns true if this hit killed the enemy.
func take_damage(amount: int) -> bool:
	hp = maxi(0, hp - amount)
	queue_redraw()
	if hp <= 0:
		print("%s is slain!" % enemy_name)
		died.emit(self)
		queue_free()
		return true
	var tween := create_tween()
	tween.tween_property(self, "scale", _base_scale * 1.15, 0.06)
	tween.tween_property(self, "scale", _base_scale, 0.12)
	return false


## Push away from overlapping packmates so goblins can't stack
## inside each other (or inside the player).
func _separation() -> Vector2:
	var push := Vector2.ZERO
	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self or not is_instance_valid(other):
			continue
		var d: Vector2 = global_position - (other as Node2D).global_position
		var dist := d.length()
		if dist > 0.01 and dist < 30.0:
			push += d.normalized() * (30.0 - dist)
	return push


func _draw() -> void:
	var skin := body_color
	var dark := dark_color
	draw_circle(Vector2(0, 8), 9.0, Color(0, 0, 0, 0.3))
	draw_colored_polygon(PackedVector2Array([Vector2(-7, -3), Vector2(-17, -9), Vector2(-7, -10)]), dark)
	draw_colored_polygon(PackedVector2Array([Vector2(7, -3), Vector2(17, -9), Vector2(7, -10)]), dark)
	draw_circle(Vector2.ZERO, 11.0, Color(0.12, 0.28, 0.12))
	draw_circle(Vector2.ZERO, 10.0, skin)
	draw_circle(Vector2(-3, -3), 4.0, Color(0.42, 0.75, 0.40))
	draw_circle(Vector2(0, 3), 5.0, Color(0.42, 0.75, 0.40))
	draw_circle(Vector2(-3.5, -2), 3.2, Color(0.85, 0.12, 0.12, 0.45))
	draw_circle(Vector2(3.5, -2), 3.2, Color(0.85, 0.12, 0.12, 0.45))
	draw_circle(Vector2(-3.5, -2), 2.0, Color(1.0, 0.25, 0.2))
	draw_circle(Vector2(3.5, -2), 2.0, Color(1.0, 0.25, 0.2))
	draw_line(Vector2(-6, -6), Vector2(-1.5, -4.5), dark, 1.5)
	draw_line(Vector2(6, -6), Vector2(1.5, -4.5), dark, 1.5)
	var frac := float(hp) / float(maxi(1, max_hp))
	var bar := Color(0.75, 0.18, 0.18)
	if frac > 0.5:
		bar = Color(0.25, 0.70, 0.25)
	elif frac > 0.25:
		bar = Color(0.85, 0.70, 0.20)
	draw_rect(Rect2(-15, -26, 30, 5), Color(0.08, 0.07, 0.09))
	if frac > 0.0:
		draw_rect(Rect2(-15, -26, 30.0 * frac, 5), bar)
