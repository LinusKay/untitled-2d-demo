extends CanvasLayer

signal seed_selected

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var line_edit: LineEdit = $Control/VBoxContainer/HBoxContainer/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Repl



func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		#texture_button_blue.grab_focus()
		animation_player.play("enter")
		await animation_player.animation_finished


func _on_button_pressed() -> void:
	PlayerManager.desired_seed = line_edit.text
	animation_player.play("leave")
	await animation_player.animation_finished
	hide()
	seed_selected.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			animation_player.play("leave")
			await animation_player.animation_finished
			get_tree().paused = false
			visible = false
