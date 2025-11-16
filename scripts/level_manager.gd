extends Node


signal level_load_started
signal level_load_finished

var target_transition_area: String
var position_offset: Vector2


func _ready() -> void:
	await get_tree().process_frame
	level_load_finished.emit()


func load_new_level(
		level_path: String,
		_target_transition_area: String,
		_position_offset: Vector2
) -> void:
	get_tree().paused = true
	target_transition_area = _target_transition_area
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(level_path)
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false 
	
	await get_tree().process_frame
	
	level_load_finished.emit()
	PlayerManager.player.state_machine.change_state(PlayerManager.player.state_machine.states[0])
