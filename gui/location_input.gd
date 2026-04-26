extends CanvasLayer

signal seed_selected

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var line_edit: LineEdit = $Control/VBoxContainer/HBoxContainer/LineEdit

@export var character_limit: int = 1
@onready var buttonback: Button = $Control/VBoxContainer/HBoxContainer3/Buttonback


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.max_length = character_limit



func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		#texture_button_blue.grab_focus()
		animation_player.play("enter")
		await animation_player.animation_finished
		line_edit.grab_focus()


func _on_button_pressed() -> void:
	PlayerManager.desired_seed = line_edit.text
	animation_player.play("leave")
	await animation_player.animation_finished
	hide()
	seed_selected.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or (event.is_action_pressed("ui_cancel") and not line_edit.has_focus()):
		if visible: hide_menu()

func hide_menu():
	animation_player.play("leave")
	await animation_player.animation_finished
	get_tree().paused = false
	visible = false		

func _unhandled_input(event: InputEvent) -> void:
	if line_edit.text.length() < line_edit.max_length:
		if line_edit.has_focus():
			if event.is_action_pressed("input_shape_circle"):
				line_edit.text += "⬤"
			elif event.is_action_pressed("input_shape_triangle"):
				line_edit.text += "▲"
			elif event.is_action_pressed("input_shape_square"):
				line_edit.text += "■"
	
	#if line_edit.text.length() >= line_edit.max_length:
		#disabled = true
	#else:
		#disabled = false


func _on_buttonback_pressed() -> void:
	if visible: hide_menu()
	
