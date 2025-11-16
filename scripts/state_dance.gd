class_name State_Dance extends State

@export var move_speed: float = 30.0
var dancing: bool = false

@onready var idle: State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

# When player enters state
func enter() -> void:
	player.update_animation("dance")
	dancing = true
	pass


func exit() -> void:
	dancing = false
	pass


func process(_delta: float) -> State:

	if dancing == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	player.velocity = player.direction * move_speed
		
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
		not _event.is_action_released("pause")
		):
		dancing = false
		return idle
	return null


func end_dance(_anim: String) -> void:
	dancing = false
