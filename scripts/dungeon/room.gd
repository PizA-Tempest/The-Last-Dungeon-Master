extends Node2D
## Draws the dungeon room procedurally: tiled floor with accent stones,
## walls with gold trim, banners, and flickering torches.
## (Wall collision stays declarative in room.tscn.)

const FLOOR_RECT := Rect2(160, 90, 960, 540)
const TILE := 48.0

var _time := 0.0


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	draw_rect(FLOOR_RECT, Color(0.13, 0.12, 0.17))
	var cols := int(FLOOR_RECT.size.x / TILE)
	var rows := int(FLOOR_RECT.size.y / TILE)
	for cx in range(cols):
		for cy in range(rows):
			if (cx * 7 + cy * 13) % 11 == 0:
				var p := FLOOR_RECT.position + Vector2(cx * TILE, cy * TILE)
				draw_rect(Rect2(p, Vector2(TILE, TILE)), Color(0.16, 0.15, 0.21))
	var grid := Color(0.09, 0.08, 0.12)
	for i in range(cols + 1):
		var x := FLOOR_RECT.position.x + i * TILE
		draw_line(Vector2(x, FLOOR_RECT.position.y), Vector2(x, FLOOR_RECT.end.y), grid, 2.0)
	for j in range(rows + 1):
		var y := FLOOR_RECT.position.y + j * TILE
		draw_line(Vector2(FLOOR_RECT.position.x, y), Vector2(FLOOR_RECT.end.x, y), grid, 2.0)
	var wall_top := Color(0.30, 0.27, 0.37)
	var wall_front := Color(0.20, 0.17, 0.25)
	# soft shadow the walls cast onto the floor
	var shadow := Color(0, 0, 0, 0.35)
	draw_rect(Rect2(144, 90, 992, 10), shadow)
	draw_rect(Rect2(144, 620, 992, 10), shadow)
	draw_rect(Rect2(160, 90, 10, 540), shadow)
	draw_rect(Rect2(1110, 90, 10, 540), shadow)
	draw_rect(Rect2(144, 58, 992, 32), wall_top)
	draw_rect(Rect2(144, 630, 992, 32), wall_front)
	draw_rect(Rect2(128, 58, 32, 604), wall_front)
	draw_rect(Rect2(1120, 58, 32, 604), wall_front)
	var trim := Color(0.55, 0.47, 0.28)
	draw_line(Vector2(144, 90), Vector2(1136, 90), trim, 2.0)
	draw_line(Vector2(144, 630), Vector2(1136, 630), trim, 2.0)
	draw_line(Vector2(160, 58), Vector2(160, 662), trim, 2.0)
	draw_line(Vector2(1120, 58), Vector2(1120, 662), trim, 2.0)
	_banner(Vector2(420, 58))
	_banner(Vector2(860, 58))
	# faded rune emblem at the room's heart
	var heart := Vector2(640, 360)
	draw_circle(heart, 96.0, Color(0.75, 0.62, 0.30, 0.05))
	draw_arc(heart, 96.0, 0.0, TAU, 48, Color(0.75, 0.62, 0.30, 0.10), 3.0)
	draw_arc(heart, 64.0, 0.0, TAU, 40, Color(0.75, 0.62, 0.30, 0.08), 2.0)
	_torch(Vector2(240, 74))
	_torch(Vector2(1040, 74))
	_embers(Vector2(240, 66))
	_embers(Vector2(1040, 66))


func _banner(top: Vector2) -> void:
	var w := 44.0
	var h := 30.0
	draw_rect(Rect2(top.x - w / 2.0, top.y, w, h), Color(0.45, 0.10, 0.12))
	draw_line(Vector2(top.x - w / 2.0, top.y), Vector2(top.x + w / 2.0, top.y), Color(0.75, 0.62, 0.30), 2.0)


func _torch(pos: Vector2) -> void:
	var flick := 1.0 + 0.15 * sin(_time * 9.0 + pos.x)
	draw_circle(pos, 26.0 * flick, Color(1.0, 0.55, 0.15, 0.10))
	draw_rect(Rect2(pos.x - 3.0, pos.y - 2.0, 6.0, 16.0), Color(0.30, 0.20, 0.12))
	draw_circle(pos + Vector2(0, -8), 8.0 * flick, Color(1.0, 0.55, 0.15))
	draw_circle(pos + Vector2(0, -8), 4.5 * flick, Color(1.0, 0.85, 0.35))


func _embers(pos: Vector2) -> void:
	for i in range(3):
		var rise := fmod(_time * 34.0 + float(i) * 15.0, 45.0)
		var wobble := sin(_time * 5.0 + float(i) * 2.1 + pos.x) * 4.0
		var fade := 1.0 - rise / 45.0
		draw_circle(pos + Vector2(wobble, -rise), 1.8, Color(1.0, 0.6, 0.2, 0.7 * fade))
