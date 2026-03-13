class_name MailLetterResource extends Resource

@export var mail_id: int
@export var mail_from: NPCResource
@export var mail_to: NPCResource
@export var mail_location: String
@export var deliver_dialogue: Array[String]
@export var post_deliver_dialogue: Array[String]
@export var mail_description: String

#text, npc_info_path, bonus_image, time, sound
