extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			animation_player.play("leave")
			await animation_player.animation_finished
			hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			show()
			animation_player.play("enter")
