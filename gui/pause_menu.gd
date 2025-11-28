extends CanvasLayer

@onready var control_pause: Control = $ControlPause
@onready var button_save: Button = $ControlPause/VBoxContainer/ButtonSave
@onready var button_load: Button = $ControlPause/VBoxContainer/ButtonLoad
@onready var button_settings: Button = $ControlPause/VBoxContainer/ButtonSettings

@onready var control_settings: Control = $ControlSettings
@onready var vol_slider_main: HSlider = $ControlSettings/VBoxContainer/HBoxVolMain/VolSliderMain
@onready var vol_slider_music: HSlider = $ControlSettings/VBoxContainer/HBoxVolMusic/VolSliderMusic
@onready var vol_slider_sfx: HSlider = $ControlSettings/VBoxContainer/HBoxVolSfx/VolSliderSfx
@onready var button_back: Button = $ControlSettings/VBoxContainer/ButtonBack


var is_active: bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_settings.pressed.connect(_show_settings_menu)
	button_back.pressed.connect(_hide_settings_menu)
	vol_slider_main.value_changed.connect(_on_vol_main_changed)
	vol_slider_music.value_changed.connect(_on_vol_music_changed)
	vol_slider_sfx.value_changed.connect(_on_vol_sfx_changed)


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
	_hide_settings_menu()
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


func _show_settings_menu() -> void:
	control_pause.hide()
	control_settings.show()
	vol_slider_main.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	vol_slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	vol_slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	


func _hide_settings_menu() -> void:
	control_pause.show()
	control_settings.hide()


func _on_vol_main_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	
func _on_vol_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	
func _on_vol_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
