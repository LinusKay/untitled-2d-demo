@tool
class_name DialogueChoice extends DialogueItem

var dialogue_branches: Array[DialogueBranch]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child: Node in get_children():
		if child is DialogueBranch:
			dialogue_branches.append(child)


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialogue_branches() == false:
		return ["Requires at least 2 DialogueBranch nodse"]
	else:
		return []


func _check_for_dialogue_branches() -> bool:
	var _count: int = 0;
	for child: Node in get_children():
		if child is DialogueBranch:
			_count += 1
			if _count > 1:
				return true
	return false
