extends Node2D
## Game scene: kill all enemies to win, fall to 0 HP to lose.
## Tracks kills via enemy `died` signals, shows Victory/Death panels,
## spawns floating damage numbers, and shakes the camera on hits.
## Uses preload (not global class names) so a fresh checkout boots
## before the editor builds the global class cache.

const DiceRollerScript := preload("res://scripts/systems/dice_roller.gd")
const XpScript := preload("res://scripts/systems/xp_system.gd")

var _rng := RandomNumberGenerator.new()
var _kills := 0
var _total := 0
var _shake := 0.0

@onready var _camera: Camera2D = $Camera
@onready var _victory: Control = $VictoryPanel
@onready var _death: Control = $DeathPanel
@onready var _popups: Node2D = $Popups
@onready var _hud: Control = $Hud


func _ready() -> void:
	_rng.randomize()
	var outcome: Dictionary = DiceRollerScript.roll(_rng, 3, 2)
	print("The Last Dungeon Master booted. D20=%d final=%d (%s)" % [
		outcome["base"],
		outcome["final"],
		DiceRollerScript.result_name(outcome["result"]),
	])
	var enemies := get_tree().get_nodes_in_group("enemies")
	_total = enemies.size()
	for enemy in enemies:
		if enemy.has_signal("died"):
			enemy.connect("died", _on_enemy_died)
	_hud.log("Slay all %d monsters! WASD/arrows move, SPACE/click attack, T spends a Fate Token reroll (%d available)." % [_total, 3])
	($VictoryPanel/Center/Card/VBox/RestartButton as Button).pressed.connect(_restart)
	($DeathPanel/Center/Card/VBox/RestartButton as Button).pressed.connect(_restart)


func _process(delta: float) -> void:
	if _shake > 0.0:
		_shake = maxf(0.0, _shake - delta * 24.0)
		_camera.offset = Vector2(randf_range(-_shake, _shake), randf_range(-_shake, _shake))
	elif _camera.offset != Vector2.ZERO:
		_camera.offset = Vector2.ZERO


func shake(strength: float) -> void:
	_shake = maxf(_shake, strength)


func spawn_popup(world_pos: Vector2, text: String, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.position = world_pos + Vector2(-14, -40)
	_popups.add_child(label)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 36.0, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(label.queue_free)


func game_over() -> void:
	_death.visible = true


func _on_enemy_died(enemy: Node) -> void:
	_kills += 1
	var player := get_tree().get_first_node_in_group("player")
	if player != null and player.has_method("add_xp"):
		player.add_xp(XpScript.xp_for_kill(int(enemy.get("max_hp"))))
	_hud.log("%s slain! (%d/%d)" % [enemy.get("enemy_name"), _kills, _total])
	if _kills >= _total:
		_victory.visible = true
		_hud.log("Victory! The room is cleared... for now.")


func _restart() -> void:
	get_tree().reload_current_scene()
