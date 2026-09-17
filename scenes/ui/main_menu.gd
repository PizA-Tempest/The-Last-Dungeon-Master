extends Control
## Main menu (Phase 1): title + Start / Quit. Start loads the game scene.


func _ready() -> void:
	print("Main menu ready. Press Start to enter the dungeon.")
	($Center/VBox/StartButton as Button).pressed.connect(_on_start_pressed)
	($Center/VBox/QuitButton as Button).pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
