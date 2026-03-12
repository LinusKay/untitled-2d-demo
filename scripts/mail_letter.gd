class_name MailLetter extends Node

@export var mail_id: int
@export var mail_from: NPCResource
@export var mail_to: NPCResource
@export var mail_location: String
@export var deliver_dialogue: Array[DialogueItem]
@export var mail_description: String

## Creates a new MailLetter object 
## _mail_id: A unique identifier for the mail object 
func _init(_mail_id: int, _mail_from: NPCResource, _mail_to: NPCResource, _mail_location: String, _mail_description: String = "", _deliver_dialogue: Array[DialogueItem] = []) -> void:
	mail_id = _mail_id
	mail_from = _mail_from
	mail_to = _mail_to
	mail_location = _mail_location
	mail_description = _mail_description
	deliver_dialogue = _deliver_dialogue
