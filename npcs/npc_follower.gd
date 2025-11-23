extends Node2D

const EMOTE_BUBBLE: PackedScene = preload("uid://d143re016yja2")

var ACCELERATION: float
var FRICTION: float

@onready var sprite: Sprite2D = $Sprite2D

var _player_moving: bool = false
var _target_pos: Vector2
var _look_dir: Vector2
var _last_look_dir_y: float = 1

func _ready() -> void:
	PlayerManager.player.send_bubble.connect(_bubble_response)


func _bubble_response() -> void:
	var bubble: Node2D = EMOTE_BUBBLE.instantiate()
	add_child(bubble)


func setup(sprite_texture: String) -> void:
	if sprite_texture:
		sprite.texture = load(sprite_texture)

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
	
	else:
		pass
