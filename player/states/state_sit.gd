class_name State_Sit extends State

var sitting: bool = false

@onready var idle: State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var dance: State_Dance = $"../dance"

# When player enters state
func enter() -> void:
	player.update_animation("sit")
	sitting = true
	pass


func exit() -> void:
	sitting = false
	pass


func process(_delta: float) -> State:

	if sitting == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	player.velocity = Vector2.ZERO
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	if (
		not _event.is_action_pressed("sit") and 
		not _event.is_action_released("sit") and
		not _event.is_action_pressed("dance") and 
		not _event.is_action_released("dance") and
		not _event.is_action_pressed("bubble") and
		not _event.is_action_released("bubble") and
		not _event.is_action_pressed("pause") and
		not _event.is_action_released("pause") and 
		not _event is InputEventMouse
		):
		sitting = false
		return idle
	if _event.is_action_pressed("dance"):
		sitting = false
		return dance
	return null
