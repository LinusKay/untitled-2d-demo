@tool
class_name DialogueInteraction extends InteractionArea

signal player_interacted
signal finished

@export var enabled: bool = true

var dialogue_items: Array[DialogueItem]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	interact = Callable(self, "_player_interact")
	body_entered.connect(_player_entered)
	body_exited.connect(_player_exited)
	
	for child: Node in get_children():
		if child is DialogueItem:
			dialogue_items.append(child)


func _player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	DialogueSystem.show_dialogue(dialogue_items)
	DialogueSystem.finished.connect(_on_dialogue_finished)


func _player_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)
	
func _player_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialogue_items() == false:
		return ["Requires at least one DialogueItem child node."]
	else:
		return []


func _check_for_dialogue_items() -> bool:
	for child: Node in get_children():
		if child is DialogueItem:
			return true
	return false


func _on_dialogue_finished() -> void:
	DialogueSystem.finished.disconnect(_on_dialogue_finished)
	finished.emit()
