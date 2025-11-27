class_name LevelTileMapSetup extends TileMapLayer


func _ready() -> void:
	var level: Level = get_tree().get_first_node_in_group("level")
	if level is LevelProcGen:
		LevelManager.change_tilemap_bounds(get_procgen_bounds())
	else:
		LevelManager.change_tilemap_bounds(get_tilemap_bounds())


func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size)
	)
	return bounds

func get_procgen_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	#var width = 
	return bounds
