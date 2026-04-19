class_name MailLetter extends Node



@export var mail_letter_resource: MailLetterResource

func _init(_mail_letter_resource: MailLetterResource) -> void:
	mail_letter_resource = _mail_letter_resource


func get_mail_id() -> int:
	return mail_letter_resource.mail_id


func get_from() -> NPCResource:
	return mail_letter_resource.mail_from


func get_to() -> NPCResource:
	return mail_letter_resource.mail_to


func get_location() -> String:
	return mail_letter_resource.mail_location


func get_delivery_dialogue() -> Array[DialogueItem]:
	return parse_dialogue_string_array(mail_letter_resource.deliver_dialogue)


func get_delivery_dialogue_raw() -> Array[String]:
	return mail_letter_resource.deliver_dialogue


func get_post_deliver_dialogue() -> Array[DialogueItem]:
	return parse_dialogue_string_array(mail_letter_resource.post_deliver_dialogue)


func get_post_deliver_dialogue_raw() -> Array[String]:
	return mail_letter_resource.post_deliver_dialogue


func get_pre_deliver_dialogue() -> Array[DialogueItem]:
	return parse_dialogue_string_array(mail_letter_resource.pre_deliver_dialogue)


func get_pre_deliver_dialogue_raw() -> Array[String]:
	return mail_letter_resource.pre_deliver_dialogue


func get_description() -> String:
	return mail_letter_resource.mail_description


func parse_dialogue_string_array(_dialogue_string_array: Array[String]) -> Array[DialogueItem]:
	var SCR_DIALOGUE_TEXT: Script = preload("res://gui/dialogue_system/dialogue_text.gd")
	var dialogueuitem_array: Array[DialogueItem] = []
	for item: String in _dialogue_string_array:
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
		dialogueuitem_array.append(node)
	return dialogueuitem_array


func get_mail_stamp() -> MailStamp: 
	return mail_letter_resource.mail_stamp
