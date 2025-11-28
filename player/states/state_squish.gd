class_name State_Squish extends State

@export var move_speed: float = 30.0
var squishing: bool = false

@onready var idle: State_Idle = $"../idle"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

# When player enters state
func enter() -> void:
	squishing = true
	player.update_animation("squish")
	animation_player.animation_finished.connect(_on_squish_finish)

func exit() -> void:
	pass


func process(_delta: float) -> State:
	if squishing == false:
		return idle
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	if (
		not _event.is_action_pressed("dance") and 
		not _event.is_action_released("dance") and
		not _event.is_action_pressed("bubble") and
		not _event.is_action_released("bubble") and
		not _event.is_action_pressed("pause") and
		not _event.is_action_released("pause") and
		not _event is InputEventMouse
		):
		return idle
	return null


func _on_squish_finish(_anim: String) -> void:
	animation_player.animation_finished.disconnect(_on_squish_finish)
	squishing = false


func _on_player_player_click() -> void:
	player.state_machine.change_state(self)
