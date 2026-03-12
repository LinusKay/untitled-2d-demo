extends CanvasLayer

var tscn_mail_letter_h_box: PackedScene = preload("res://gui/mail_letter_h_box.tscn")
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_no_mail: Label = $Control/LabelNoMail


var is_active: bool = false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#_show_menu()


func _show_menu() -> void:
	get_tree().paused = true
	is_active = true
	_refresh_mail()
	if v_box_container.get_children().size() == 0:
		label_no_mail.show()
	else:
		label_no_mail.hide()
	show()
	animation_player.play("enter")
	await animation_player.animation_finished


func _refresh_mail() -> void:
	for child: HBoxContainer in v_box_container.get_children():
		v_box_container.remove_child(child)
		child.queue_free()
	for mail: MailLetter in MailManager.get_mail_bag():
		var mail_letter_h_box: HBoxContainer = tscn_mail_letter_h_box.instantiate()
		mail_letter_h_box.mail = mail
		v_box_container.add_child(mail_letter_h_box)

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
			
	if event.is_action_pressed("pause"):
		if is_active:
			_hide_menu()
			get_viewport().set_input_as_handled()
