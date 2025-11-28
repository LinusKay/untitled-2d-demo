extends Node2D

const EMOTE_BUBBLE: PackedScene = preload("uid://d143re016yja2")

var ACCELERATION: float
var FRICTION: float

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _player_moving: bool = false
var _target_pos: Vector2
var _look_dir: Vector2
var _last_look_dir_y: float = 1

var npc_info: Resource

func _ready() -> void:
	PlayerManager.player.send_bubble.connect(_bubble_response)


func _bubble_response() -> void:
	var bubble: Node2D = EMOTE_BUBBLE.instantiate()
	bubble.frame = npc_info.bubble_indexes.pick_random()
	add_child(bubble)
	if npc_info.voices:
		audio_stream_player.stream = npc_info.voices.pick_random()
		audio_stream_player.pitch_scale = randf_range(0.8,1.1)
		audio_stream_player.play()


func setup(_npc_info: Resource) -> void:
	npc_info = _npc_info
	sprite.texture = npc_info.npc_name_sprite


func _physics_process(delta: float) -> void:
	var old_pos: Vector2 = global_position
	var pos_lerp_weight: float = 1.0 - exp( -(ACCELERATION if _player_moving else FRICTION) * delta)
	global_position = lerp(global_position, _target_pos, pos_lerp_weight)
	
	if _look_dir.y:
		_last_look_dir_y = _look_dir.y
	if global_position.distance_to(old_pos) > 0.1:
		if _look_dir.x:
			if sprite:
				sprite.flip_h = true if _look_dir.x < 0 else false
