@tool
class_name DialogueBranch extends DialogueItem


@export var text: String = "ok"

var dialogue_items: Array[DialogueItem]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child: Node in get_children():
		if child is DialogueItem:
			dialogue_items.append(child)
