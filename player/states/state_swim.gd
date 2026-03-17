class_name State_Swim extends State

@export var move_speed: float = 50.0

@onready var idle: State_Idle = $"../idle"
@onready var jump: State_Jump = $"../jump"

# When player enters state
func enter() -> void:
	player.update_animation("swim")
	player.swimming = true
	pass


func exit() -> void:
	player.swimming = false
	pass


func process(_delta: float) -> State:
	#if player.direction == Vector2.ZERO:
		#return idle
	if not player.check_water_depth() > 2.0:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("swim")
	
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	#if _event.is_action_pressed("jump"):
		#return jump
	return null
