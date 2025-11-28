class_name FriendSelect extends CanvasLayer

signal friend_chosen

var is_active: bool = true

@onready var texture_button_blue: TextureButton = $Control/HBoxContainer/PanelPortraitBlue/TextureButtonBlue
@onready var texture_button_orange: TextureButton = $Control/HBoxContainer/PanelPortraitOrange/TextureButtonOrange
@onready var texture_button_green: TextureButton = $Control/HBoxContainer/PanelPortraitGreen/TextureButtonGreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var line_edit: SeedInput = $Control/LineEdit


func _ready() -> void:
	PlayerManager.desired_seed = ""


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		texture_button_blue.grab_focus()
		animation_player.play("enter")
		await animation_player.animation_finished


func on_friend_chosen(_npc_info: Resource) -> void:
	_set_seed()
	PlayerManager.followers = []
	PlayerManager.followers.append(_npc_info)
	animation_player.play("leave")
	await animation_player.animation_finished
	friend_chosen.emit()
	visible = false

func _on_button_pressed() -> void:
	_set_seed()
	animation_player.play("leave")
	await animation_player.animation_finished
	get_tree().paused = false
	friend_chosen.emit()
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			animation_player.play("leave")
			await animation_player.animation_finished
			get_tree().paused = false
			visible = false


func _set_seed() -> void:
	if line_edit.text:
		PlayerManager.desired_seed = line_edit.text
