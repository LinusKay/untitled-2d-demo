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
	
	collect_dialogue_items() 
	
	
func collect_dialogue_items() -> void:
	dialogue_items = []
	for child: Node in get_children():
		if child is DialogueItem and is_instance_valid(child):
			dialogue_items.append(child)
			print("collecting item ")
			#print(child.text)
	print("collected dialogue: " + str(dialogue_items))

func _player_interact() -> void:
	print("player interact")
	player_interacted.emit()
	var parent_npc: Node = get_parent()
	if parent_npc is NPC:
		if "npc_info" in parent_npc:
			if parent_npc.npc_info.awaiting_mail:
				_choice_talk_deliver()
				return
	await get_tree().process_frame
	_perform_dialogue()



func _choice_talk_deliver() -> void:
	print("talk, or deliver mail?")
	ChoiceTalkOrDeliver.show()
	ChoiceTalkOrDeliver._on_visibility_changed()
	# wtf ^^ ?
	ChoiceTalkOrDeliver.talk_pressed.connect(_perform_dialogue)
	ChoiceTalkOrDeliver.deliver_pressed.connect(_perform_delivery)
	
	
func _perform_dialogue() -> void:
	print("perform dialolgue")
	DialogueSystem.show_dialogue(dialogue_items)
	DialogueSystem.finished.connect(_on_dialogue_finished)
	if ChoiceTalkOrDeliver.talk_pressed.is_connected(_perform_dialogue):
		ChoiceTalkOrDeliver.talk_pressed.disconnect(_perform_dialogue)
	if ChoiceTalkOrDeliver.deliver_pressed.is_connected(_perform_delivery):
		ChoiceTalkOrDeliver.deliver_pressed.disconnect(_perform_delivery)


func _perform_delivery() -> void:
	print("dewivering mail")
	if ChoiceTalkOrDeliver.talk_pressed.is_connected(_perform_dialogue):
		ChoiceTalkOrDeliver.talk_pressed.disconnect(_perform_dialogue)
	if ChoiceTalkOrDeliver.deliver_pressed.is_connected(_perform_delivery):
		ChoiceTalkOrDeliver.deliver_pressed.disconnect(_perform_delivery)
	MailManager.deliver_mail(get_parent())
	

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


func clear_dialogue() -> void:
	print("clear dialogue")
	print(dialogue_items[0].text)
	for child: Node in get_children():
		if child is DialogueItem:
			remove_child(child)
			child.queue_free()
	dialogue_items = []
	print(dialogue_items)


func set_dialogue(_dialogue_items: Array[DialogueItem]) -> void:
	print("set dialogue")
	print(dialogue_items)
	print("setting provided dialogue: " + _dialogue_items[0].text)
	for dialogue_item: DialogueItem in _dialogue_items:
		add_child(dialogue_item)
	collect_dialogue_items() 
	print(dialogue_items[0].text)
