class_name MailLetter extends Node

@export var mail_id: int
@export var mail_to: String
@export var mail_location: String
@export var mail_from: String

## Creates a new MailLetter object 
## _mail_id: A unique identifier for the mail object 
func _init(_mail_id: int, _mail_from: String, _mail_to: String, _mail_location: String) -> void:
	mail_id = _mail_id
	mail_from = _mail_from
	mail_to = _mail_to
	mail_location = _mail_location
