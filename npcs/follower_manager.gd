extends Node2D

var followers: Array[Node2D] = []
var distance_spacing: float = 20.0
var _trail_points: Array[Vector2]
const FOLLOWER_SCENE_PRELOAD: PackedScene = preload("res://npcs/npc_follower.tscn")
var player: Player
var stacks_on: bool = false

func _ready() -> void:
	player = PlayerManager.player
	#LevelManager.level_load_finished.connect(_level_load_spawn)\
	var test_followers: Array[Resource] = [
		#load("res://npcs/npc_blue/npc_resource_blue.tres"),
		#load("res://npcs/npc_green/npc_resource_green.tres"),
		#load("res://npcs/npc_orange/npc_resource_orange.tres")
	]
	for f: Resource in test_followers:
		#spawn_follower(f.npc_name_sprite.load_path)
		spawn_follower(f)
	for f: Resource in PlayerManager.followers:
		#spawn_follower(f.npc_name_sprite.load_path)
		spawn_follower(f)
#func _level_load_spawn() -> void:
	#var level: Level = get_tree().get_first_node_in_group("level")
	#for i:int in followers.size():
		#followers[i].queue_free()
	#if level.followers_allowed:
		#print("followers allowed")


func _physics_process(_delta: float) -> void:
	#print(player.swimming)
	if player.swimming:
		stacks_on = true
		distance_spacing = 1.0
	else:
		stacks_on = false
		distance_spacing = 20.0
	_follower_logic()


# https://www.youtube.com/watch?v=vePeZQNZkxA
func _follower_logic() -> void:
	if stacks_on:
		_trail_points = [player.global_position]
	else:
		if _trail_points.is_empty() or _trail_points[0].distance_to(player.global_position) >= 1.0:
			_trail_points.push_front(player.global_position)
			
		var max_trail_length: float = followers.size() * distance_spacing
		while _trail_points.size() > max_trail_length:
			_trail_points.pop_back()
		
	for i: int in followers.size():
		var path_pos: Vector2 = get_point_along_trail(distance_spacing * (i + 1))
		followers[i]._player_moving = true if round(player.velocity) else false
		followers[i]._target_pos = path_pos
		followers[i]._look_dir = round((followers[i].global_position - path_pos).normalized()) * -1
		if stacks_on: 
			followers[i].y_sort_enabled = false
			followers[i].z_index = 10
			followers[i].ACCELERATION = 50.0
			followers[i].FRICTION = 50.0
			followers[i]._target_pos = path_pos + Vector2(0, -16 * ( i + 1))
		else:
			followers[i].y_sort_enabled = true
			followers[i].z_index = 0
			followers[i].ACCELERATION = 10.0
			followers[i].FRICTION = 10.0
			


func get_point_along_trail(distance: float) -> Vector2:
	var total: float = 0.0
	for i: int in range(_trail_points.size() - 1):
		var point_a: Vector2 = _trail_points[i]
		var point_b: Vector2 = _trail_points[i + 1]
		var segment_length: float= point_a.distance_to(point_b)
		if total + segment_length >= distance:
			var t: float = (distance - total) / segment_length
			return point_a.lerp(point_b, t)
		total += segment_length
	return _trail_points.back()


func spawn_follower(_npc_info: Resource) -> void:
	var new_follower_scene: Node2D = FOLLOWER_SCENE_PRELOAD.instantiate()
	
	new_follower_scene.ACCELERATION = 10.0
	new_follower_scene.FRICTION = 10.0

	if _trail_points.is_empty():
		_trail_points.append(player.global_position)
	new_follower_scene.global_position = get_point_along_trail(distance_spacing * (followers.size() + 1))
	
	get_parent().add_child.call_deferred(new_follower_scene)

	new_follower_scene.setup.call_deferred(_npc_info)
	
	followers.append(new_follower_scene)


func remove_follower(index: int) -> void:
	if not followers.is_empty():
		if followers.size() >= index + 1:
			followers[index].queue_free()
			followers.remove_at(index)
		printerr("Could not remove follower '", str(index), "'. Out of bounds.")


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#remove_follower(0)
