@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level: String
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 2: 
	set(_value):
		size = _value
		_update_area()
@export var side: SIDE = SIDE.LEFT:
	set(_value):
		side = _value
		_update_area()
@export var snap_to_grid: bool = false:
	set(_value):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var point: Sprite2D = $Point


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player()
	
	await LevelManager.level_load_finished
	
	monitoring = true
	body_entered.connect(_player_entered)


func _player_entered(_player: Node2D) -> void:
	print(name, "player entered")
	LevelManager.load_new_level(level, target_transition_area, _get_offset())


func _place_player() -> void:
	if name != LevelManager.target_transition_area: 
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)


func _get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_pos: Vector2 = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 8
		if side == SIDE.LEFT:
			offset.x *= -1
	elif side == SIDE.TOP or side == SIDE.BOTTOM:
		offset.x = player_pos.x - global_position.x
		offset.y = 8
		if side == SIDE.TOP:
			offset.y *= -1
		
	return offset


func _update_area() -> void:
	var new_rect: Vector2 = Vector2(16, 16)
	var new_pos: Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_pos.y -= 8
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_pos.y += 8
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_pos.x -= 8
		if point:
			point.position.x = -26
			point.scale.x = -1
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_pos.x += 8
		if point:
			point.position.x = 26
			point.scale.x = 1
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_pos


func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8
