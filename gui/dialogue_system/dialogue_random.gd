@tool
class_name DialogueRandom extends DialogueItem

var dialogue_items: Array[DialogueItem]

# used to create random dialogue sequences, eg:
# DialogueText
# DialogueRandom
# - DialogueBranch
# - - DialogueText
# - DialogueBranch2
# - - DialogueText
# DialogueText

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child: Node in get_children():
		if child is DialogueItem:
			dialogue_items.append(child)
