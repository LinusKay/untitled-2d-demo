extends HBoxContainer

@export var mail: MailLetter

@onready var label_from: RichTextLabel = $LabelFrom
@onready var label_to: RichTextLabel = $LabelTo
@onready var label_location: RichTextLabel = $LabelLocation
@onready var label_description: RichTextLabel = $LabelDescription


func _ready() -> void:
	var mail_from_head: String = ""
	if mail.mail_from.chat_portrait_sprite:
		mail_from_head = "[img]" + mail.mail_from.chat_portrait_sprite.resource_path + "[/img]"
	label_from.text = "From: " + mail_from_head + mail.mail_from.npc_name
	
	var mail_to_head: String = ""
	if mail.mail_to.chat_portrait_sprite:
		mail_to_head = "[img]" + mail.mail_to.chat_portrait_sprite.resource_path + "[/img]"
	label_to.text = "To: " + mail_to_head + mail.mail_to.npc_name
	
	label_location.text = "Location: " + mail.mail_location
	#label_description.text = mail.label_description
