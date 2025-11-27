extends CanvasLayer

@onready var button_save: Button = $VBoxContainer/ButtonSave
@onready var button_load: Button = $VBoxContainer/ButtonLoad
@onready var button_mute: Button = $ButtonMute

var is_active: bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_mute.pressed.connect(_on_mute_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_active == false:
			if DialogueSystem.is_active:
				return
			if InventoryMenu.is_active:
				return
			if ReputationManager.is_active:
				return
			if LevelManager.is_transitioning:
				return
			for ui: Node in get_tree().get_nodes_in_group("temp_ui"):
				if ui.visible:
					return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_active = true
	button_save.grab_focus()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_active = false


func _on_save_pressed() -> void:
	if is_active == false:
		return
	SaveManager.save_game()
	hide_pause_menu()


func _on_load_pressed() -> void:
	if is_active == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()


func _on_mute_pressed() -> void:
	AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))
