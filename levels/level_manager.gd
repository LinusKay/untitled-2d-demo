extends Node


signal level_load_started
signal level_load_finished

var target_transition_area: String
var position_offset: Vector2

var current_tilemap_bounds: Array[Vector2]
signal tilemap_bounds_changed(bounds: Array[Vector2])

var loading_level_path: String = ""

var is_transitioning: bool = false

func _ready() -> void:
	await get_tree().process_frame
	level_load_finished.emit()


func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)


func load_new_level(
		level_path: String,
		_target_transition_area: String,
		_position_offset: Vector2
) -> void:
	is_transitioning = true
	get_tree().paused = true
	target_transition_area = _target_transition_area
	position_offset = _position_offset
	
	loading_level_path = level_path
	
	await SceneTransition.fade_out()
	
	SceneTransition.scene_path = level_path
	ResourceLoader.load_threaded_request(level_path)
	
	level_load_started.emit()


func finish_load() -> void:
	var scene: PackedScene = ResourceLoader.load_threaded_get(loading_level_path)
	#get_tree().change_scene_to_packed(scene)
	var scene_instance: Node = scene.instantiate()
	get_tree().current_scene.add_child(scene_instance)
	
	#await get_tree().process_frame
	MusicManager.change_music(scene_instance.level_music)
	
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false 
	
	await get_tree().process_frame
	
	is_transitioning = false
	level_load_finished.emit()
	PlayerManager.player.state_machine.change_state(PlayerManager.player.state_machine.states[0])
	loading_level_path = ""
