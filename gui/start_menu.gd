class_name StartMenu extends Control

@onready var button_start: Button = $VBoxContainer/ButtonStart
@onready var button_quit: Button = $VBoxContainer/ButtonQuit

var start_level: String = "res://levels/scenes/level2.tscn"

func _ready() -> void:
	button_start.pressed.connect(_on_start_pressed)
	button_quit.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	LevelManager.place_player = true
	LevelManager.load_new_level(start_level, "", Vector2.ZERO)
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()
