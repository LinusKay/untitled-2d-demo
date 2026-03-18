class_name InteractionMailbox extends InteractionArea

signal player_interact

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
	MailManager.mailbox_pickup()
	MailMenu._show_menu()
	MailManager.check_room_recipients()
	player_interact.emit()
