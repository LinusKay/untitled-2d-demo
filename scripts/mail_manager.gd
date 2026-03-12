extends Node

var next_free_id: int = 0

var mail_bag: Array[MailLetter] = []
var delivered_mail: Array[MailLetter] = []

var SCR_DIALOGUE_TEXT: Script = preload("res://gui/dialogue_system/dialogue_text.gd")

func _ready() -> void:
	var del_dia_doctor_1: Node = Node.new()
	del_dia_doctor_1.set_script(SCR_DIALOGUE_TEXT)
	del_dia_doctor_1.text = "MY MAIL!! ZOWOWOWOW ZAMMMM!!"
	del_dia_doctor_1.npc_info = load("res://npcs/npc_doctor/npc_resource_doctor.tres")
	var del_dia_doctor_2: Node = Node.new()
	del_dia_doctor_2.set_script(SCR_DIALOGUE_TEXT)
	del_dia_doctor_2.text = "IU LOVE YOU "
	del_dia_doctor_2.npc_info = load("res://npcs/npc_doctor/npc_resource_doctor.tres")
	var letter_dialogue: Array[DialogueItem] = [del_dia_doctor_1, del_dia_doctor_2]
	
	create_mail(
		load("res://npcs/npc_orange/npc_resource_orange.tres"),
		load("res://npcs/npc_blue/npc_resource_blue.tres"),
		"▲"
	)
	create_mail(
		load("res://npcs/npc_blue/npc_resource_blue.tres"),
		load("res://npcs/npc_doctor/npc_resource_doctor.tres"),
		"▲",
		"Letter to a donctor",
		letter_dialogue
	)

	debug_pring_mail()
	#delete_mail(1)
	#debug_pring_mail()
	

func get_mail_bag() -> Array[MailLetter]:
	return mail_bag


## Raw prints out current mail bag contents
func debug_pring_mail() -> void:
	for mail: MailLetter in mail_bag:
		print(mail.mail_id, mail.mail_from, mail.mail_to, mail.mail_location)
	

## Safely creates a new mail object with a unique ID
##
## Returns the newly created MailLetter object
func create_mail(_mail_from: NPCResource, _mail_to: NPCResource, _mail_location: String, _mail_description: String = "", _delivery_dialogue: Array[DialogueItem] = []) -> MailLetter:
	var new_mail: MailLetter = MailLetter.new(
		next_free_id,
		_mail_from,
		_mail_to,
		_mail_location,
		_mail_description,
		_delivery_dialogue
	)
	next_free_id += 1
	mail_bag.append(new_mail)
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
		create_mail(
			load("res://npcs/npc_blue/npc_resource_blue.tres"),
			load("res://npcs/npc_doctor/npc_resource_doctor.tres"),
			"▲"
		)
		MailMenu._refresh_mail()
		check_room_recipients()


func check_room_recipients() -> bool:
	var mail_recipients: Array[NPCResource] = []
	for mail: MailLetter in mail_bag:
		if not mail_recipients.has(mail.mail_to):
			mail_recipients.append(mail.mail_to)
	
	var npcs: Array[Node] = get_tree().get_nodes_in_group("npc")
	for npc: Node in npcs:
		if "npc_info" in npc:
			if mail_recipients.has(npc.npc_info):
				npc.set_awaiting_mail(true)
				continue
		if "set_awaiting_mail" in npc:
			npc.set_awaiting_mail(false)
	return false


func _get_mail_for_recipient(recipient_npc_info: NPCResource) -> Array[MailLetter]:
	var recipient_mail: Array[MailLetter] = []
	for mail: MailLetter in mail_bag: 
		if mail.mail_to == recipient_npc_info:
			recipient_mail.append(mail)
	return recipient_mail


func deliver_mail(recipient_npc_info: NPCResource) -> void:
	var recipient_mail: Array[MailLetter] = _get_mail_for_recipient(recipient_npc_info)
	for mail: MailLetter in recipient_mail:
		var mail_index: int = mail_bag.find(mail)
		mail_bag.remove_at(mail_index)
		delivered_mail.append(mail)
		if mail.deliver_dialogue.size() > 0:
			DialogueSystem.show_dialogue(mail.deliver_dialogue)
	check_room_recipients()
	
