extends Node

const SAVE_PATH: String = "user://"

signal game_loaded
signal game_saved


var current_save: Dictionary = {
	time = "",
	scene_path = "",
	player = {
		pos_x = 0,
		pos_y = 0,
		state = ""
	},
	dialogue = {
		dialogue_items = [],
		dialogue_item_index = 0
	},
	items = [],
	persistence = [],
	quests = []
}


func save_game() -> void:
	update_scene_path()
	update_player_data()
	update_dialogue_data()
	current_save.time = Time.get_unix_time_from_system()
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
	var state: State = PlayerManager.player.get_node("StateMachine/" + current_save.player.state)
	PlayerManager.player.state_machine.change_state(state)
	
	DialogueSystem.dialogue_item_index = current_save.dialogue.dialogue_item_index
	var new_dialogue_items: Array[DialogueItem] = []
	for item: Dictionary in current_save.dialogue.dialogue_items:
		var dialogue_text: DialogueText = DialogueText.new()
		dialogue_text.text = item.text
		dialogue_text.npc_info = load(item.npc_info_path)
		if item.bonus_image_path:
			dialogue_text.bonus_image = load(item.bonus_image_path)
		new_dialogue_items.append(dialogue_text)
	DialogueSystem.dialogue_items = new_dialogue_items
	
	await LevelManager.level_load_finished

	game_loaded.emit()


func update_player_data() -> void:
	var player: Player = PlayerManager.player
	current_save.player.pos_x = player.global_position.x
	current_save.player.pos_y = player.global_position.y
	current_save.player.state = player.state_machine.curr_state.name


func update_scene_path() -> void:
	var path: String = ""
	for child: Node in get_tree().root.get_children():
		if child is Level:
			path = child.scene_file_path
	current_save.scene_path = path


func update_dialogue_data() -> void:
	current_save.dialogue.dialogue_items = []
	var dialogue_items: Array[DialogueItem] = DialogueSystem.dialogue_items
	for item: DialogueItem in dialogue_items:
		var item_dict: Dictionary = {}
		item_dict.text = item.text
		item_dict.npc_info_path = item.npc_info.resource_path
		current_save.dialogue.dialogue_items.append(item_dict)
		if item.bonus_image:
			item_dict.bonus_image_path = item.bonus_image.resource_path
		else: 
			item_dict.bonus_image_path = ""
	var dialogue_item_index: int = DialogueSystem.dialogue_item_index
	current_save.dialogue.dialogue_item_index = dialogue_item_index
	pass


func add_persistent_value(value: String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)


func check_persistent_value(value: String) -> bool:
	var persistence: Array = current_save.persistence
	return persistence.has(value)
