class_name State_Drive extends State

@export var move_speed: float = 20.0

@onready var idle: State_Idle = $"../idle"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
	
	
# When player enters state
func enter() -> void:
	player.update_animation("idle")
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
	player.velocity = player.direction * move_speed
	player.set_direction()
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func _on_player_car_enter() -> void:
	player.state_machine.change_state(self)


func _on_player_car_exit() -> void:
	player.state_machine.change_state(idle)
