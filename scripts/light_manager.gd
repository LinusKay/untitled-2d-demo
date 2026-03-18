extends Node

@onready var canvas_modulate: CanvasModulate = $CanvasModulate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.level_fade_in.connect(setup_scene_lighting)
	TimeManager.time_changed.connect(setup_scene_lighting)
	setup_scene_lighting()

func get_light_nodes() -> Array[Node]:
	var lights: Array[Node] = get_tree().get_nodes_in_group("light")
	return lights


func setup_scene_lighting() -> void:
	
	# allow level to be properly loaded and referenceable in group
	await get_tree().process_frame
	var level: Level = get_tree().get_first_node_in_group("level")

	var lights: Array[Node] = get_light_nodes()
	var time: int = TimeManager.get_time()
	print(time)
	for light: Node2D in lights:
		if level.ignore_light:
			light.enabled = false
			canvas_modulate.color = "ffffff"
		elif time < TimeManager.time_blocks.TIME_NOON:
			light.enabled = false
			canvas_modulate.color = "ffffff"
		elif time >= TimeManager.time_blocks.TIME_NOON and time < TimeManager.time_blocks.TIME_NIGHT:
			light.enabled = false
			canvas_modulate.color = "f0c8a4"
		elif time >= TimeManager.time_blocks.TIME_NIGHT:
			light.enabled = true
			canvas_modulate.color = "2c44ff"
