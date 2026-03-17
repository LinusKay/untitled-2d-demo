extends Node

var next_free_id: int = 0

var mail_bag: Array[MailLetter] = []
var delivered_mail: Array[MailLetter] = []

var SCR_DIALOGUE_TEXT: Script = preload("res://gui/dialogue_system/dialogue_text.gd")


func _ready() -> void:
	#var new_mail: MailLetter = create_mail(
		#load("res://interactions/mail/letters/mail_letter_TEST_01.tres"),
	#)
	#mail_bag.append(new_mail)
	pass
	

func get_mail_bag() -> Array[MailLetter]:
	return mail_bag


## Raw prints out current mail bag contents
func debug_print_mail() -> void:
	for mail: MailLetter in mail_bag:
		print(mail.mail_id, mail.mail_from, mail.mail_to, mail.mail_location)
	

## Safely creates a new mail object with a unique ID
##
## Returns the newly created MailLetter object
func create_mail(_mail_letter_resource: MailLetterResource) -> MailLetter:
	_mail_letter_resource.mail_id = next_free_id
	var new_mail: MailLetter = MailLetter.new(
		_mail_letter_resource
	)
	next_free_id += 1
	
	return new_mail


## Takes a mail ID and checks the mail bag for it
##  
## If mail is found and deleted, returns true
## Otherwise, returns false
func delete_mail(_mail_id: int) -> bool:
	for mail_index: int in mail_bag.size():
		if mail_bag[mail_index].mail_id == _mail_id:
			mail_bag.remove_at(mail_index)
			return true
	return false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_mail"):
		var new_mail: MailLetter = create_mail(
			load("res://interactions/mail/letters/mail_letter_TEST_02.tres"),
		)
		mail_bag.append(new_mail)
		MailMenu._refresh_mail()
		check_room_recipients()


func check_room_recipients() -> bool:
	var mail_recipients: Array[NPCResource] = []
	var mail_to_deliver: Array[MailLetter] = []
	for mail: MailLetter in mail_bag:
		if not mail_recipients.has(mail.get_to()):
			mail_recipients.append(mail.get_to())
			mail_to_deliver.append(mail)
	
	var npcs: Array[Node] = get_tree().get_nodes_in_group("npc")
	for npc: Node in npcs:
		if "npc_info" in npc:
			if mail_recipients.has(npc.npc_info):
				npc.set_awaiting_mail(true)
				var first_letter: MailLetter = mail_to_deliver[0]
				if first_letter.get_pre_deliver_dialogue().size() > 0:
					print("pre deliver dialogue mhm")
					npc.clear_dialogue()
					npc.set_dialogue(first_letter.get_pre_deliver_dialogue())
				continue
		if "set_awaiting_mail" in npc:
			npc.set_awaiting_mail(false)
	return false


func _get_mail_for_recipient(recipient_npc_info: NPCResource) -> Array[MailLetter]:
	var recipient_mail: Array[MailLetter] = []
	for mail: MailLetter in mail_bag: 
		if mail.get_to() == recipient_npc_info:
			recipient_mail.append(mail)
	return recipient_mail


func deliver_mail(recipient_npc: NPC) -> void:
	PlayerManager.player.player_deliver.emit()
	var recipient_npc_info: NPCResource = recipient_npc.npc_info
	var recipient_mail: Array[MailLetter] = _get_mail_for_recipient(recipient_npc_info)
	for mail: MailLetter in recipient_mail:
		var mail_index: int = mail_bag.find(mail)
		mail_bag.remove_at(mail_index)
		delivered_mail.append(mail)
		if mail.get_delivery_dialogue().size() > 0:
			DialogueSystem.show_dialogue(mail.get_delivery_dialogue())
		if mail.get_post_deliver_dialogue().size() > 0:
			recipient_npc.clear_dialogue()
			recipient_npc.set_dialogue(mail.get_post_deliver_dialogue())
	check_room_recipients()
	
