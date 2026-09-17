extends CharacterBody2D
## Top-down player (Phase 1 prototype).
## Movement: move_left/move_right/move_up/move_down (arrows + WASD,
## bound by physical keycode in project.godot so any layout works).
## Attack: `attack` action (Space/Enter) or left-click hits the nearest
## enemy in range, then the enemy retaliates — the basic turn exchange.
## Fate Tokens (`use_fate`, T): reroll the last missed attack.
## Class stats load from data/characters/<class_id>.json; XP/levels via
## scripts/systems/xp_system.gd. Combat math lives in
## scripts/combat/melee.gd; cross-script refs use preload so fresh
## checkouts boot before the editor builds the global class cache.
## Looks (adventurer + sword + slash arc) are drawn in _draw().

const MeleeScript := preload("res://scripts/combat/melee.gd")
const FateScript := preload("res://scripts/systems/fate_system.gd")
const XpScript := preload("res://scripts/systems/xp_system.gd")

@export var speed := 200.0
@export var max_hp := 100
@export var strength_bonus := 3
@export var weapon_bonus := 2
@export var attack_range := 64.0
@export var attack_cooldown := 0.5
@export var class_id := "warrior"
@export var fate_tokens := 3

var hp: int
var level := 1
var xp := 0
var dexterity_bonus := 2
var intelligence_bonus := 1
var constitution_bonus := 5
var charisma_bonus := 2
var _missed_target: Node = null
var _face := Vector2.RIGHT
var _slash_t := 0.0
var _base_scale := Vector2.ONE
var _rng := RandomNumberGenerator.new()
var _cooldown := 0.0


func _ready() -> void:
	add_to_group("player")
	hp = max_hp
	_base_scale = scale
	_rng.randomize()
	_load_class()
	_hud_set_hp()
	queue_redraw()


func _process(delta: float) -> void:
	if _slash_t > 0.0:
		_slash_t -= delta
		queue_redraw()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length() > 0.1:
		_face = direction.normalized()
		queue_redraw()
	velocity = direction * speed
	move_and_slide()
	_cooldown = maxf(0.0, _cooldown - delta)


## Input lives here, NOT in _physics_process: is_action_just_pressed()
## misses presses on physics frames. Unhandled (not _input) so UI
## buttons consume their own clicks first.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		try_attack()
	elif event.is_action_pressed("use_fate"):
		use_fate_token()
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			try_attack()


func try_attack() -> void:
	if hp <= 0 or _cooldown > 0.0:
		return
	_cooldown = attack_cooldown
	var target := _nearest_enemy()
	if target == null:
		_say("No enemy in range — walk closer!")
		return
	var to_target: Vector2 = (target as Node2D).global_position - global_position
	if to_target.length() > 0.01:
		_face = to_target.normalized()
	_slash_t = 0.15
	queue_redraw()
	_missed_target = null
	_resolve_strike(target, _rng.randi_range(1, 20), true)


## Spend a Fate Token to reroll the last missed attack. No extra
## retaliation — the enemy already acted on the original miss.
func use_fate_token() -> void:
	if hp <= 0:
		return
	if fate_tokens <= 0:
		_say("No Fate Tokens left!")
		return
	if _missed_target == null or not is_instance_valid(_missed_target):
		_say("No missed attack to reroll — miss first, then press T.")
		return
	if global_position.distance_to((_missed_target as Node2D).global_position) > attack_range:
		_say("Too far — get back in range to reroll.")
		return
	var rerolled: Dictionary = FateScript.reroll(
		fate_tokens, _rng.randi_range(1, 20), strength_bonus, weapon_bonus)
	if not rerolled["ok"]:
		return
	var target: Node = _missed_target
	_missed_target = null
	fate_tokens = rerolled["tokens"]
	_say("Fate Token spent (%d left). Rerolling..." % fate_tokens)
	_resolve_strike(target, int(rerolled["roll"]["base"]), false)


func _resolve_strike(target: Node, base_roll: int, can_retaliate: bool) -> void:
	var outcome: Dictionary = MeleeScript.resolve_player_attack(
		base_roll, strength_bonus, weapon_bonus, target.defense)
	if outcome["self_hit"] > 0:
		take_damage(outcome["self_hit"])
		_popup(global_position, "-1", Color(1.0, 0.3, 0.3))
		_say("D20=%d Critical Failure! You fumble and take 1 damage. HP %d/%d." % [outcome["base"], hp, max_hp])
		return
	if outcome["damage"] <= 0:
		_missed_target = target
		_popup((target as Node2D).global_position, "MISS", Color(0.7, 0.7, 0.75))
		_say("D20=%d (%s) — miss! (Press T to spend a Fate Token.)" % [outcome["base"], outcome["name"]])
	else:
		_main_shake(5.0)
		_popup((target as Node2D).global_position, "-%d" % outcome["damage"], Color(1.0, 0.85, 0.35))
		var killed: bool = target.take_damage(outcome["damage"])
		_say("D20=%d (%s): %d damage to %s (%d/%d)." % [
			outcome["base"], outcome["name"], outcome["damage"],
			target.enemy_name, target.hp, target.max_hp])
		if killed:
			return
	if can_retaliate:
		_retaliate(target)


func take_damage(amount: int) -> void:
	hp = maxi(0, hp - amount)
	_hud_set_hp()
	_punch()
	if hp <= 0:
		print("YOU HAVE FALLEN. The dungeon remembers your failure.")
		set_physics_process(false)
		var main := _main()
		if main != null and main.has_method("game_over"):
			main.game_over()


func _punch() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", _base_scale * 1.15, 0.06)
	tween.tween_property(self, "scale", _base_scale, 0.12)


func _retaliate(target: Node) -> void:
	var strike: Dictionary = MeleeScript.resolve_enemy_attack(
		_rng.randi_range(1, 20), target.attack)
	if strike["damage"] <= 0:
		_say("%s rolls D20=%d — misses!" % [target.enemy_name, strike["base"]])
	else:
		_main_shake(7.0)
		_popup(global_position, "-%d" % strike["damage"], Color(1.0, 0.3, 0.3))
		take_damage(strike["damage"])
		_say("%s rolls D20=%d and hits for %d! Your HP %d/%d." % [
			target.enemy_name, strike["base"], strike["damage"], hp, max_hp])


func _draw() -> void:
	var outline := Color(0.10, 0.12, 0.22)
	draw_circle(Vector2(0, 10), 10.0, Color(0, 0, 0, 0.3))
	draw_rect(Rect2(-8, 4, 6, 7), Color(0.35, 0.22, 0.12))
	draw_rect(Rect2(2, 4, 6, 7), Color(0.35, 0.22, 0.12))
	draw_circle(Vector2.ZERO, 12.0, outline)
	draw_circle(Vector2.ZERO, 11.0, Color(0.25, 0.45, 0.80))
	draw_circle(Vector2(-3, -3), 4.0, Color(0.35, 0.56, 0.92))
	draw_line(Vector2(-9, 3), Vector2(9, 3), Color(0.45, 0.30, 0.15), 3.0)
	draw_circle(Vector2(0, -3), 8.0, outline)
	draw_circle(Vector2(0, -3), 7.0, Color(0.95, 0.80, 0.65))
	draw_arc(Vector2(0, -3), 7.0, PI, TAU, 12, Color(0.40, 0.25, 0.12), 3.0)
	var perp := Vector2(-_face.y, _face.x)
	var base := _face * 10.0
	var tip := _face * 24.0
	draw_line(base, tip, Color(0.75, 0.85, 1.0, 0.45), 6.0)
	draw_line(base, tip, Color(0.85, 0.87, 0.90), 3.0)
	draw_line(base + perp * 4.0, base - perp * 4.0, Color(0.75, 0.60, 0.25), 2.0)
	if _slash_t > 0.0:
		var a := _face.angle()
		draw_arc(Vector2.ZERO, 32.0, a - 0.9, a + 0.9, 16, Color(1.0, 0.9, 0.5, 0.5), 7.0)
		draw_arc(Vector2.ZERO, 28.0, a - 0.9, a + 0.9, 16, Color(1, 1, 1, 0.9), 4.0)


## Stats come from data/characters/<class_id>.json. Missing file or
## fields keep the current values, so the game always boots.
func _load_class() -> void:
	var path := "res://data/characters/%s.json" % class_id
	if not FileAccess.file_exists(path):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not (parsed is Dictionary):
		return
	var data: Dictionary = parsed
	var stats: Dictionary = data.get("stats", {})
	strength_bonus = int(stats.get("strength", strength_bonus))
	dexterity_bonus = int(stats.get("dexterity", dexterity_bonus))
	intelligence_bonus = int(stats.get("intelligence", intelligence_bonus))
	constitution_bonus = int(stats.get("constitution", constitution_bonus))
	charisma_bonus = int(stats.get("charisma", charisma_bonus))
	max_hp = int(data.get("hp", max_hp))
	hp = max_hp


func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	xp += amount
	while xp >= XpScript.xp_needed(level):
		xp -= XpScript.xp_needed(level)
		level += 1
		var bonus: Dictionary = XpScript.level_bonuses()
		max_hp += int(bonus["max_hp"])
		strength_bonus += int(bonus["strength"])
		hp = max_hp
		_hud_set_hp()
		_say("LEVEL UP! Now level %d: HP %d, STR %d." % [level, max_hp, strength_bonus])


func _nearest_enemy() -> Node:
	var best: Node = null
	var best_dist := attack_range
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		var dist: float = global_position.distance_to((enemy as Node2D).global_position)
		if dist < best_dist:
			best = enemy
			best_dist = dist
	return best


func _main() -> Node:
	return get_tree().current_scene


func _main_shake(strength: float) -> void:
	var main := _main()
	if main != null and main.has_method("shake"):
		main.shake(strength)


func _popup(world_pos: Vector2, text: String, color: Color) -> void:
	var main := _main()
	if main != null and main.has_method("spawn_popup"):
		main.spawn_popup(world_pos, text, color)


func _hud() -> Node:
	return get_tree().get_first_node_in_group("hud")


func _hud_set_hp() -> void:
	var hud := _hud()
	if hud != null and hud.has_method("set_hp"):
		hud.set_hp(hp, max_hp)


func _say(text: String) -> void:
	print(text)
	var hud := _hud()
	if hud != null and hud.has_method("log"):
		hud.log(text)
