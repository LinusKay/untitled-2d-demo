class_name MailLetter extends Node



@export var mail_letter_resource: MailLetterResource

func _init(_mail_letter_resource: MailLetterResource) -> void:
	mail_letter_resource = _mail_letter_resource
	
#@export var mail_id: int
#@export var mail_from: NPCResource
#@export var mail_to: NPCResource
#@export var mail_location: String
#@export var deliver_dialogue: Array[DialogueItemResource]
#@export var post_deliver_dialogue: Array[DialogueItemResource]
#@export var mail_description: String

## Creates a new MailLetter object 
## _mail_id: A unique identifier for the mail object 
#func _init(_mail_id: int, _mail_from: NPCResource, _mail_to: NPCResource, _mail_location: String, _mail_description: String = "", _deliver_dialogue: Array[DialogueItem] = [], _post_deliver_dialogue: Array[DialogueItem] = []) -> void:
	#mail_id = _mail_id
	#mail_from = _mail_from
	#mail_to = _mail_to
	#mail_location = _mail_location
	#mail_description = _mail_description
	#deliver_dialogue = _deliver_dialogue
	#post_deliver_dialogue = _post_deliver_dialogue

func get_mail_id() -> int:
	return mail_letter_resource.mail_id


func get_from() -> NPCResource:
	return mail_letter_resource.mail_from


func get_to() -> NPCResource:
	return mail_letter_resource.mail_to


func get_location() -> String:
	return mail_letter_resource.mail_location


func get_delivery_dialogue() -> Array[DialogueItem]:
	var SCR_DIALOGUE_TEXT: Script = preload("res://gui/dialogue_system/dialogue_text.gd")
	var delivery_dialogue: Array[DialogueItem] = []
	for item: String in mail_letter_resource.deliver_dialogue:
		var item_split: PackedStringArray = item.split(",")
		var dialogue_text: String = item_split[0]
		var dialogue_npc_info_path: String = item_split[1]
		var dialogue_npc_info: NPCResource = load(dialogue_npc_info_path)
		var dialogue_bonus_image_path: String = item_split[2]
		var dialogue_bonus_image: CompressedTexture2D = null
		if dialogue_bonus_image_path != "null": 
			dialogue_bonus_image = load(dialogue_bonus_image_path)
		var dialogue_time: float = float(item_split[3])
		var dialogue_sound_path: String = item_split[4]
		var dialogue_sound: AudioStream = null
		if dialogue_sound_path != "null": 
			dialogue_sound = load(dialogue_sound_path)
		var node: Node = Node.new()
		node.set_script(SCR_DIALOGUE_TEXT)
		node.text = dialogue_text
		node.npc_info = dialogue_npc_info
		node.bonus_image = dialogue_bonus_image
		node.time = dialogue_time
		node.sound = dialogue_sound
		delivery_dialogue.append(node)
	return delivery_dialogue


func get_delivery_dialogue_raw() -> Array[String]:
	return mail_letter_resource.deliver_dialogue


func get_post_deliver_dialogue() -> Array[DialogueItem]:
	var SCR_DIALOGUE_TEXT: Script = preload("res://gui/dialogue_system/dialogue_text.gd")
	var post_delivery_dialogue: Array[DialogueItem] = []
	for item: String in mail_letter_resource.post_deliver_dialogue:
		var item_split: PackedStringArray = item.split(",")
		var dialogue_text: String = item_split[0]
		var dialogue_npc_info_path: String = item_split[1]
		var dialogue_npc_info: NPCResource = load(dialogue_npc_info_path)
		var dialogue_bonus_image_path: String = item_split[2]
		var dialogue_bonus_image: CompressedTexture2D = null
		if dialogue_bonus_image_path != "null": 
			dialogue_bonus_image = load(dialogue_bonus_image_path)
		var dialogue_time: float = float(item_split[3])
		var dialogue_sound_path: String = item_split[4]
		var dialogue_sound: AudioStream = null
		if dialogue_sound_path != "null": 
			dialogue_sound = load(dialogue_sound_path)
		var node: Node = Node.new()
		node.set_script(SCR_DIALOGUE_TEXT)
		node.text = dialogue_text
		node.npc_info = dialogue_npc_info
		node.bonus_image = dialogue_bonus_image
		node.time = dialogue_time
		node.sound = dialogue_sound
		post_delivery_dialogue.append(node)
	return post_delivery_dialogue


func get_post_deliver_dialogue_raw() -> Array[String]:
	return mail_letter_resource.post_deliver_dialogue


func get_description() -> String:
	return mail_letter_resource.mail_description
