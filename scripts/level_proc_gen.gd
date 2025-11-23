class_name LevelProcGen extends Level

@export var noise_height_text: NoiseTexture2D
var noise: Noise

var width: int = 1000
var height: int = 1000

var highest: float
var lowest: float

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_setup: TileMapLayer = $TileMapLayer_Setup

var layer_id_tile_map_layer: int = 0
var layer_id_tile_map_layer_setup: int = 1

var source_id: int = 0
var water_atlas: Vector2i = Vector2i(2,1)
var land_atlas: Vector2i = Vector2i(6,0)
var wall_atlas: Vector2i = Vector2i(0,0)

var purple_tiles_0: Array = []
var purple_tiles_1: Array = []
var purple_tiles_2: Array = []
var purple_tiles_3: Array = []
var terrain_purple_int: int = 0

var green_tiles_0: Array = []
var green_tiles_1: Array = []
var green_tiles_2: Array = []
var green_tiles_3: Array = []
var terrain_green_int: int = 1

var blue_tiles_0: Array = []
var blue_tiles_1: Array = []
var blue_tiles_2: Array = []
var blue_tiles_3: Array = []
var terrain_blue_int: int = 2

var yellow_tiles_0: Array = []
var yellow_tiles_1: Array = []
var yellow_tiles_2: Array = []
var yellow_tiles_3: Array = []
var terrain_yellow_int: int = 3

var cell_array: Array = []


func _ready() -> void:
	noise = noise_height_text.noise
	generate_world()


func generate_world() -> bool:
	print("generate")
	for x: float in range(-width/2.0, width/2.0):
		for y: float in range(-height/2.0, height/2.0):
			var noise_val: float = noise.get_noise_2d(x, y)
			cell_array.append(noise_val)
	highest = cell_array.max()
	lowest = cell_array.min()
	
	for x: float in range(-width/2.0, width/2.0):
		for y: float in range(-height/2.0, height/2.0):
			# normalise the value to within the max
			var noise_val: float = lerp(0.0, highest, noise.get_noise_2d(x, y))
			# placing ground
			if noise_val >= 0.0 and noise_val < 0.1:
				if noise_val <= 0.025:
					purple_tiles_0.append(Vector2(x,y))
				elif noise_val > 0.025 and noise_val <= 0.05:
					purple_tiles_1.append(Vector2(x,y))
				elif noise_val > 0.05 and noise_val <= 0.075:
					purple_tiles_2.append(Vector2(x,y))
				elif noise_val > 0.075:
					purple_tiles_3.append(Vector2(x,y))
			elif noise_val >= 0.1 and noise_val < 0.2:
				if noise_val <= 0.125:
					green_tiles_0.append(Vector2(x,y))
				elif noise_val > 0.125 and noise_val <= 0.15:
					green_tiles_1.append(Vector2(x,y))
				elif noise_val > 0.15 and noise_val <= 0.175:
					green_tiles_2.append(Vector2(x,y))
				elif noise_val > 0.175:
					green_tiles_3.append(Vector2(x,y))
			elif noise_val >= 0.2 and noise_val < 0.3:
				if noise_val <= 0.225:
					yellow_tiles_0.append(Vector2(x,y))
				elif noise_val > 0.225 and noise_val <= 0.25:
					yellow_tiles_1.append(Vector2(x,y))
				elif noise_val > 0.25 and noise_val <= 0.275:
					yellow_tiles_2.append(Vector2(x,y))
				elif noise_val > 0.275:
					yellow_tiles_3.append(Vector2(x,y))
			elif noise_val < 0.0:
				pass
				#tile_map_layer_setup.set_cell(Vector2(x, y), layer_id_tile_map_layer_setup, wall_atlas)
				##if noise_val < -0.1:
					##tile_map_layer_setup.set_cell(Vector2(x, y), layer_id_tile_map_layer_setup, wall_atlas)
				#if noise_val >= -0.1:
					#blue_tiles_0.append(Vector2(x,y))
				#elif noise_val >= -0.2 and noise_val < -0.1:
					#blue_tiles_1.append(Vector2(x,y))
				#elif noise_val >= -0.3 and noise_val < -0.2:
					#blue_tiles_2.append(Vector2(x,y))
				#elif noise_val >= -0.4 and noise_val < -0.3:
					#blue_tiles_3.append(Vector2(x,y))
			else:
				#tile_map_layer.set_cell(Vector2(x, y), layer_id_tile_map_layer, Vector2i(0,0))
				pass
				
	print("higherst", cell_array.max())
	print("lowest", cell_array.min())
	
	tile_map_layer.set_cells_terrain_connect(purple_tiles_0, terrain_purple_int, 0)
	tile_map_layer.set_cells_terrain_connect(purple_tiles_1, terrain_purple_int, 1)
	tile_map_layer.set_cells_terrain_connect(purple_tiles_2, terrain_purple_int, 2)
	tile_map_layer.set_cells_terrain_connect(purple_tiles_3, terrain_purple_int, 3)
	
	tile_map_layer.set_cells_terrain_connect(green_tiles_0, terrain_green_int, 0)
	tile_map_layer.set_cells_terrain_connect(green_tiles_1, terrain_green_int, 1)
	tile_map_layer.set_cells_terrain_connect(green_tiles_2, terrain_green_int, 2)
	tile_map_layer.set_cells_terrain_connect(green_tiles_3, terrain_green_int, 3)
	
	
	tile_map_layer.set_cells_terrain_connect(yellow_tiles_0, terrain_yellow_int, 0)
	tile_map_layer.set_cells_terrain_connect(yellow_tiles_1, terrain_yellow_int, 1)
	tile_map_layer.set_cells_terrain_connect(yellow_tiles_2, terrain_yellow_int, 2)
	tile_map_layer.set_cells_terrain_connect(yellow_tiles_3, terrain_yellow_int, 3)
	
	tile_map_layer.set_cells_terrain_connect(blue_tiles_0, terrain_blue_int, 0)
	tile_map_layer.set_cells_terrain_connect(blue_tiles_1, terrain_blue_int, 1)
	tile_map_layer.set_cells_terrain_connect(blue_tiles_2, terrain_blue_int, 2)
	tile_map_layer.set_cells_terrain_connect(blue_tiles_3, terrain_blue_int, 3)
	
	return true
