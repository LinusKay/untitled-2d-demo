class_name State_Jump extends State

@export var move_speed: float = 100.0
var jumping: bool = false

@onready var idle: State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


# When player enters state
func enter() -> void:
	player.update_animation("jump")
	animation_player.animation_finished.connect(end_jump)
	jumping = true
	pass


func exit() -> void:
	animation_player.animation_finished.disconnect(end_jump)
	jumping = false
	pass


func process(_delta: float) -> State:

	if jumping == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	player.velocity = player.direction * move_speed
		
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func end_jump(_anim: String) -> void:
	jumping = false
