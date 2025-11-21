class_name State_Idle extends State

@onready var walk: State_Walk = $"../walk"
@onready var jump: State_Jump = $"../jump"
@onready var dance: Node = $"../dance"

# When player enters state
func enter() -> void:
	player.update_animation("idle")
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("jump"):
		return jump
	if _event.is_action_pressed("dance"):
		return dance
	return null
