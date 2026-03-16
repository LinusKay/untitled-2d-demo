class_name State_Deliver extends State

@export var move_speed: float = 0.0
var delivering: bool = false

@onready var idle: State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sit: State_Sit = $"../sit"

# When player enters state
func enter() -> void:
	player.update_animation("deliver")
	print('deliver')
	delivering = true
	pass


func exit() -> void:
	delivering = false
	pass


func process(_delta: float) -> State:
	delivering = false
	if delivering == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	player.velocity = player.direction * move_speed
		
	return null


func physics(_delta: float) -> State:
	return null


#func handle_input(_event: InputEvent) -> State:
	#if (
		#not _event.is_action_pressed("dance") and 
		#not _event.is_action_released("dance") and
		#not _event.is_action_pressed("sit") and 
		#not _event.is_action_released("sit") and
		#not _event.is_action_pressed("bubble") and
		#not _event.is_action_released("bubble") and
		#not _event.is_action_pressed("pause") and
		#not _event.is_action_released("pause") and
		#not _event is InputEventMouse
		#):
		#delivering = false
		#return idle
	#return null


func _on_player_player_deliver() -> void:
	player.state_machine.change_state(self)
