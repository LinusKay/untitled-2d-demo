extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var progress_bar: ProgressBar = $Control/ColorRect/TextureRect/ProgressBar


var scene_path: String
var progress_value: float = 0.0


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true


func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true


func _process(delta: float) -> void:
	if not scene_path:
		return
		
	var progress: Array = []
	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * 100
		
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150)
		
		if progress_bar.value >= 99:
			scene_path = ""
			fade_in()
