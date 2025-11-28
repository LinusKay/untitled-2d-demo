class_name PlayerCamera extends Camera2D

var zoom_goal: float = 1.0

func _ready() -> void:
	LevelManager.tilemap_bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_tilemap_bounds)


func update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)


func _process(_delta: float) -> void:
	zoom = lerp(zoom, Vector2(zoom_goal, zoom_goal), 0.1)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom"): zoom_goal = 0.75
	elif event.is_action_released("zoom"): zoom_goal = 1.0

	if event.is_action_pressed("screenshot"):
		screenshot()
	
func screenshot() -> void:
	var screenshot_path: String = "user://screenshot_" + str(Time.get_unix_time_from_system()) + ".png"
	var image: Image = get_viewport().get_texture().get_image()
	image.save_png(screenshot_path)
