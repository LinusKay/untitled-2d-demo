class_name Level extends Node2D

@export var level_music: AudioStream
@export var followers_allowed: bool = true

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	MusicManager.change_music(level_music)
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())
	

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()


func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	var tile_map_layer_setup: TileMapLayer = get_node("TileMapLayer_Setup")
	if tile_map_layer_setup:
		bounds.append(
			Vector2(tile_map_layer_setup.get_used_rect().position * tile_map_layer_setup.rendering_quadrant_size)
		)
		bounds.append(
			Vector2(tile_map_layer_setup.get_used_rect().end * tile_map_layer_setup.rendering_quadrant_size)
		)
	return bounds


#func get_procgen_bounds() -> Array[Vector2]:
	#var bounds: Array[Vector2] = []
	#bounds.append(
		#Vector2(-width/2, -height/2)
	#)
	#bounds.append(
		#Vector2(tile_map_layer_setup.get_used_rect().end * tile_map_layer_setup.rendering_quadrant_size)
	#)
	#return bounds
