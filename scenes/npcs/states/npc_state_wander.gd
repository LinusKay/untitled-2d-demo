class_name NPCStateWander extends NPCState

@export var anim_name: String = "walk"
@export var walk_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3

var _timer: float = 0.0
var _direction: Vector2


func init() -> void:
	pass


func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand: int = randi_range(0, npc.DIR_4.size() - 1)
	_direction = npc.DIR_4[rand]
	npc.velocity = _direction * walk_speed
	npc.set_direction(_direction)
	npc.update_animation(anim_name)
	

func exit() -> void:
	pass


func process(_delta: float) -> NPCState:
	_timer -= _delta
	if _timer <= 0: 
		return next_state
	return null


func physics(_delta: float) -> NPCState:
	return null
