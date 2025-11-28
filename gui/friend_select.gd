class_name FriendSelect extends CanvasLayer

signal friend_chosen

var is_active: bool = true

@onready var texture_button_blue: TextureButton = $Control/HBoxContainer/PanelPortraitBlue/TextureButtonBlue
@onready var texture_button_orange: TextureButton = $Control/HBoxContainer/PanelPortraitOrange/TextureButtonOrange
@onready var texture_button_green: TextureButton = $Control/HBoxContainer/PanelPortraitGreen/TextureButtonGreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var line_edit: SeedInput = $Control/LineEdit
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	PlayerManager.followers = []
	PlayerManager.desired_seed = ""


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		texture_button_blue.grab_focus()
		animation_player.play("enter")
		await animation_player.animation_finished


func on_friend_chosen(_npc_info: Resource) -> void:
	_set_seed()
	PlayerManager.followers.append(_npc_info)
	animation_player.play("leave")
	if _npc_info.voices:
		audio_stream_player_2d.stream = _npc_info.voices.pick_random()
		audio_stream_player_2d.pitch_scale = randf_range(0.8,1.1)
		audio_stream_player_2d.play()
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
