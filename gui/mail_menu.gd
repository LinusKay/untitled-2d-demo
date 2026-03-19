extends CanvasLayer

var tscn_mail_menu_item: PackedScene = preload("res://gui/mail_menu_item.tscn")
@onready var mail_holder: Control = $Control/MailHolder
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_no_mail: Label = $Control/LabelNoMail

var mail_selected: int = 0

var is_active: bool = false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#_show_menu()


func _show_menu() -> void:
	get_tree().paused = true
	is_active = true
	_refresh_mail()
	if mail_holder.get_children().size() == 0:
		label_no_mail.show()
	else:
		label_no_mail.hide()
	show()
	animation_player.play("enter")
	await animation_player.animation_finished


func _refresh_mail() -> void:
	for child: Control in mail_holder.get_children():
		if child is MailMenuItem:
			mail_holder.remove_child(child)
			child.queue_free()
	for mail: MailLetter in MailManager.get_mail_bag():
		var mail_menu_item: Control = tscn_mail_menu_item.instantiate()
		mail_menu_item.mail = mail
		mail_holder.add_child(mail_menu_item)

func _hide_menu() -> void:
	is_active = false
	get_tree().paused = false
	animation_player.play("leave")
	await animation_player.animation_finished
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if DialogueSystem.is_active:
			return
		if PauseMenu.is_active:
			return
		if ReputationManager.is_active:
			return
		if LevelManager.is_transitioning:
			return
		for ui: Node in get_tree().get_nodes_in_group("temp_ui"):
			if ui.visible and ui != self:
				return
		if visible:
			_hide_menu()
		else:
			_show_menu()
			
	elif event.is_action_pressed("mail_close"):
		if is_active:
			_hide_menu()
			get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("mail_right") and is_active: 
		_selection_increase()
	elif event.is_action_pressed("mail_left") and is_active:
		_selection_decrease()


func _selection_increase() -> void:
	mail_selected += 1
	if mail_selected > MailManager.mail_bag.size() - 1:
		mail_selected = 0
	_update_mail_stack()

func _selection_decrease() -> void:
	mail_selected -= 1
	if mail_selected < 0:
		mail_selected = MailManager.mail_bag.size() - 1
	_update_mail_stack()

func _update_mail_stack() -> void:
	var letters: Array[Node] = mail_holder.get_children()
	for letter: Node in letters:
		letter.hide()
	if MailManager.mail_bag.size() > 0:
		letters[mail_selected].show()
