class_name LevelProcGen extends Level

@export var noise_texture: NoiseTexture2D
var noise: Noise

@export var width: int = 100
@export var height: int = 100


var highest: float
var lowest: float


@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_setup: TileMapLayer = $TileMapLayer_Setup
@onready var tile_map_layer_decor: TileMapLayer = $TileMapLayer_Decor

var layer_id_tile_map_layer: int = 0
var layer_id_tile_map_layer_setup: int = 0

var layer_id_tile_map_layer_flowers: int = 0
var layer_id_tile_map_layer_crystals: int = 1

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
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	MusicManager.change_music(level_music)
	if not noise_texture:
		noise_texture = NoiseTexture2D.new()
	if not noise_texture.noise:
		noise_texture.noise = FastNoiseLite.new()
		noise_texture.noise.set_seed(randi())
	noise_texture.noise.frequency = 0.0075
	noise = noise_texture.noise
	print(noise.seed)
	
	generate_world()

var TERRAIN_CONFIG: Array[Dictionary] = [
	{
		"name": "blue",
		"range": Vector2(-0.4, 0.0),
		"thresholds": [-0.1, -0.2, -0.3, -0.4]
	}
]

func generate_world() -> bool:
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
			
			if noise_val < 0.0:
				if noise_val >= -0.1:
					blue_tiles_0.append(Vector2(x,y))
				elif noise_val >= -0.2 and noise_val < -0.1:
					blue_tiles_1.append(Vector2(x,y))
				elif noise_val >= -0.3 and noise_val < -0.2:
					blue_tiles_2.append(Vector2(x,y))
				elif noise_val >= -0.4 and noise_val < -0.3:
					blue_tiles_3.append(Vector2(x,y))
				else:
					blue_tiles_3.append(Vector2(x,y))
					
			elif noise_val >= 0.0 and noise_val < 0.1:
				_chance_spawn_item(x, y, "sands")
				if noise_val <= 0.025:
					yellow_tiles_2.append(Vector2(x,y))
				elif noise_val > 0.025 and noise_val <= 0.05:
					yellow_tiles_1.append(Vector2(x,y))
				elif noise_val > 0.05:
					yellow_tiles_0.append(Vector2(x,y))
				#elif noise_val > 0.075:
					#yellow_tiles_3.append(Vector2(x,y))
			#elif noise_val >= 0.0 and noise_val < 0.1:
				#if noise_val <= 0.025:
					#purple_tiles_0.append(Vector2(x,y))
				#elif noise_val > 0.025 and noise_val <= 0.05:
					#purple_tiles_1.append(Vector2(x,y))
				#elif noise_val > 0.05 and noise_val <= 0.075:
					#purple_tiles_2.append(Vector2(x,y))
				#elif noise_val > 0.075:
					#purple_tiles_3.append(Vector2(x,y))
					
			elif noise_val >= 0.1 and noise_val < 0.2:
				_chance_place_decor(x, y, "grass")
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
					purple_tiles_0.append(Vector2(x,y))
					_chance_place_decor(x, y, "crystal", 0.5, [0, 1])
				elif noise_val > 0.225 and noise_val <= 0.25:
					purple_tiles_1.append(Vector2(x,y))
					_chance_place_decor(x, y, "crystal", 0.4, [0, 1, 2])
				elif noise_val > 0.25 and noise_val <= 0.275:
					purple_tiles_2.append(Vector2(x,y))
					_chance_place_decor(x, y, "crystal", 0.4)
				elif noise_val > 0.275:
					purple_tiles_3.append(Vector2(x,y))
					_chance_place_decor(x, y, "crystal", 0.5)
					
			elif noise_val > 0.3:
				yellow_tiles_3.append(Vector2(x,y))
				_chance_spawn_item(x, y, "sands")
			
			else:
				tile_map_layer_setup.set_cell(Vector2(x, y), layer_id_tile_map_layer_setup, wall_atlas)
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

func _chance_spawn_item(x: float, y: float, _biome: String) -> void:
	if randf() < 0.003: 
		var fossil_sprite: Sprite2D = Sprite2D.new()
		fossil_sprite.y_sort_enabled = true
		if randf() < 0.5:
			fossil_sprite.texture = load("res://sprites/loot/fossil-1.png")
		else:
			fossil_sprite.texture = load("res://sprites/loot/fossil-2.png")
		fossil_sprite.global_position.x = (x * 16) + 8
		fossil_sprite.global_position.y = (y * 16) + 8
		add_child(fossil_sprite)

func _chance_place_decor(x: float, y: float, _biome: String, _chance: float = 0.5, _tile_limits: Array = []) -> void:
	var layer: int = 0
	if _biome == "grass":
		layer = 0
	elif _biome == "crystal":
		layer = 1
	if randf() < _chance: 
		var tile: int
		if _tile_limits != []:
			tile = _tile_limits.pick_random()
		else:
			tile = randi_range(0, 3)
		tile_map_layer_decor.set_cell(Vector2(x, y), layer, Vector2i(tile, 0))
