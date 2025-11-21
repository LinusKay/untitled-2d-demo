class_name NPCStateChase extends NPCState

@export var anim_name: String = "walk"
@export var walk_speed: float = 20.0
@export var turn_rate: float = 0.25

@export_category("AI")
@export var vision_area: VisionArea
@export var state_chase_duration: float = 0.5
@export var chill_distance: float = 15


var _timer: float = 0.0
var _direction: Vector2
var _can_see_player: bool = false


func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)


func enter() -> void:
	_timer = state_chase_duration
	npc.update_animation(anim_name)
	

func exit() -> void:
	_can_see_player = false
	pass


func process(_delta: float) -> NPCState:
	var distance: float = npc.global_position.distance_to(PlayerManager.player.global_position)
	if distance <= chill_distance:
		return next_state
	var new_dir: Vector2 = npc.global_position.direction_to(PlayerManager.player.global_position)
	_direction = lerp(_direction, new_dir, turn_rate)
	npc.velocity = _direction * walk_speed
	if npc.set_direction(_direction):
		npc.update_animation(anim_name)
	
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0: 
			return next_state
	else:
		_timer = state_chase_duration
	return null


func physics(_delta: float) -> NPCState:
	return null


func _on_player_enter() -> void:
	_can_see_player = true
	state_machine.change_state(self)


func _on_player_exit() -> void:
	_can_see_player = false
