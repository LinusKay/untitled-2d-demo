extends CanvasLayer

signal talk_pressed
signal deliver_pressed

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_visibility_changed() -> void:
	if visible:
		_show_menu()


func _show_menu() -> void:
	animation_player.play("enter")
	

func _hide_menu() -> void:
	animation_player.play("leave")
	await animation_player.animation_finished
	print(visible)
	hide()
	print(visible)


func _on_button_talk_pressed() -> void:
	_hide_menu()
	talk_pressed.emit()


func _on_button_deliver_pressed() -> void:
	_hide_menu()
	deliver_pressed.emit()
