extends VisibleOnScreenNotifier2D

@onready var level_transition_indicator: Sprite2D = $LevelTransitionIndicator


func _on_screen_exited() -> void:
	level_transition_indicator.show()
	pass


func _on_screen_entered() -> void:
	level_transition_indicator.hide()
	pass

# with a little help from: https://inputrandomness.com/figuring-out-godot-2d-screen-edge-pointers-and-bonus-picture-in-picture/
func _process(_delta: float) -> void:
	var inverse_canvas_transform: Transform2D = get_tree().root.canvas_transform.affine_inverse()
	var viewport_rect: Rect2 = get_viewport_rect()
	var upper_left: Vector2 = inverse_canvas_transform * Vector2.ZERO
	var lower_right: Vector2 = inverse_canvas_transform * viewport_rect.size
	var offset: Vector2 = Vector2(8, 8)
	
	var clamped_position: Vector2 = global_position.clamp(upper_left + offset, lower_right - offset)
	if clamped_position != level_transition_indicator.global_position:
		level_transition_indicator.global_position = clamped_position
	
	if level_transition_indicator.visible:
		var dir: Vector2 = PlayerManager.player.global_position - level_transition_indicator.global_position
		var angle_step: float = PI / 4.0
		var angle_snapped: float = round(dir.angle() / angle_step) * angle_step
		level_transition_indicator.rotation = lerp_angle(level_transition_indicator.rotation, angle_snapped, 0.15)
		
