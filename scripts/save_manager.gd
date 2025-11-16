extends Node

const SAVE_PATH: String = "user://"

signal game_loaded
signal game_saved


var current_save: Dictionary = {
	scene_path = "",
	player = {
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [
		
	],
	quests = []
}


func save_game() -> void:
	update_scene_path()
	update_player_data()
	var file: FileAccess = FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json: String = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()


func load_game() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json: JSON = JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	
	await LevelManager.level_load_finished
	
	game_loaded.emit()

func update_player_data() -> void:
	var player: Player = PlayerManager.player
	current_save.player.pos_x = player.global_position.x
	current_save.player.pos_y = player.global_position.y


func update_scene_path() -> void:
	var path: String = ""
	for child: Node in get_tree().root.get_children():
		if child is Level:
			path = child.scene_file_path
	current_save.scene_path = path


func add_persistent_value(value: String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)


func check_persistent_value(value: String) -> bool:
	var persistence: Array = current_save.persistence
	return persistence.has(value)
