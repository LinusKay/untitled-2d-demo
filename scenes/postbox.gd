extends Node2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@onready var interaction_mailbox: InteractionMailbox = $InteractionMailbox

var got_mail: bool = false


func _ready() -> void:
	interaction_mailbox.player_interact.connect(check_mail)
	check_mail()


func check_mail() -> void:
	if MailManager.get_mail_box().size() > 0:
		got_mail = true
		interaction_mailbox.monitoring = true
		sprite_2d.animation = ["point", "wave"].pick_random()
		#sprite_2d.animation = "alert"
	else:
		got_mail = false
		interaction_mailbox.monitoring = false
		sprite_2d.animation = "default"
	
