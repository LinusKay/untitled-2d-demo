class_name InteractionMailbox extends InteractionArea

#@export var action_name: String = "interact"
#
#var interact: Callable = func() -> void:
	#pass
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	interact = Callable(self, "_player_interact")
	super()


func _player_interact() -> void:
	print("player interacted")
	var new_mail: MailLetter = MailManager.create_mail(
		load("res://interactions/mail/letters/mail_letter_TEST_01.tres"),
	)
	MailManager.mail_bag.append(new_mail)
	MailMenu._refresh_mail()
	MailMenu._show_menu()
	MailManager.check_room_recipients()
