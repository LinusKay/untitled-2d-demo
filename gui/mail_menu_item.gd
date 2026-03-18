class_name MailMenuItem extends Control

@export var mail: MailLetter

@onready var label_from: RichTextLabel = $VBoxContainer/LabelFrom
@onready var label_to: RichTextLabel = $VBoxContainer/LabelTo
@onready var label_location: RichTextLabel = $VBoxContainer/LabelLocation
@onready var label_description: RichTextLabel = $VBoxContainer/LabelDescription


func _ready() -> void:
	var mail_from_head: String = ""
	if mail.get_from().chat_portrait_sprite:
		mail_from_head = "[img]" + mail.get_from().chat_portrait_sprite.resource_path + "[/img]"
	label_from.text = "From: " + mail_from_head + mail.get_from().npc_name
	
	var mail_to_head: String = ""
	if mail.get_to().chat_portrait_sprite:
		mail_to_head = "[img]" + mail.get_to().chat_portrait_sprite.resource_path + "[/img]"
	label_to.text = "To: " + mail_to_head + mail.get_to().npc_name
	
	label_location.text = "Location: " + mail.get_location()
	#label_description.text = mail.label_description
