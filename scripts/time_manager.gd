extends Node

#signal time_day
#signal time_afternoon
#signal time_night

@warning_ignore("unused_signal")
signal time_changed

enum time_blocks {
	TIME_DAY = 0,
	TIME_NOON = 12,
	TIME_NIGHT = 18
}

var time: int = 0
var day: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_time() -> int:
	return time

func set_time(_time: int) -> void:
	time = _time
	time_changed.emit()
	print(name + ": time set to " + str(time))

func change_time(_time_increase: int) -> void:
	set_time(time + _time_increase)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_time_decrease"):
		change_time(-12)
	
	elif event.is_action_pressed("debug_time_increase"):
		change_time(12)
