class_name LevelProcGen extends Level

@export var noise_texture: NoiseTexture2D
var noise: Noise

@export var biome_noise_texture: NoiseTexture2D
var biome_noise: Noise

@export var width: int = 100
@export var height: int = 100


var highest: float
var lowest: float
var biome_highest: float
var biome_lowest: float

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_setup: TileMapLayer = $TileMapLayer_Setup
@onready var tile_map_layer_decor: TileMapLayer = $TileMapLayer_Decor
@onready var tile_map_layer_trees: TileMapLayer = $TileMapLayer_Trees

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

var ocean_tiles_0: Array = []
var ocean_tiles_1: Array = []
var ocean_tiles_2: Array = []
var ocean_tiles_3: Array = []
var terrain_ocean_int: int = 4

var brown_tiles_0: Array = []
var brown_tiles_1: Array = []
var brown_tiles_2: Array = []
var brown_tiles_3: Array = []
var terrain_brown_int: int = 5

var cell_array: Array = []
var biome_cell_array: Array = []

var biome_threshold_purple: float = 0.2
var biome_threshold_brown: float = 0.15

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	LevelManager.change_tilemap_bounds(get_procgen_bounds())
	MusicManager.change_music(level_music)
	
	if not noise_texture:
		noise_texture = NoiseTexture2D.new()
	if not noise_texture.noise:
		noise_texture.noise = FastNoiseLite.new()
		noise_texture.noise.set_seed(randi())
	noise_texture.noise.frequency = 0.0075
	noise_texture.noise.noise_type = 3
	noise = noise_texture.noise
	
	if not biome_noise_texture:
		biome_noise_texture = NoiseTexture2D.new()
	if not biome_noise_texture.noise:
		biome_noise_texture.noise = FastNoiseLite.new()
		biome_noise_texture.noise.set_seed(randi())
	biome_noise_texture.noise.frequency = 0.01
	biome_noise_texture.noise.noise_type = 2
	biome_noise = biome_noise_texture.noise
	
	
	generate_world()

var TERRAIN_CONFIG: Array[Dictionary] = [
	{
		"name": "blue",
		"range": Vector2(-0.4, 0.0),
		"thresholds": [-0.1, -0.2, -0.3, -0.4]
	}
]


# alternate to get_tilemap_bounds for normal levels
func get_procgen_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	bounds.append(Vector2(-width/2.0 * 16, -height/2.0 * 16))
	bounds.append(Vector2(width/2.0 * 16, height/2.0 * 16))
	return bounds


func generate_world() -> bool:
	for x: float in range(-width/2.0, width/2.0):
		for y: float in range(-height/2.0, height/2.0):
			if x == -height/2.0: tile_map_layer_setup.set_cell(Vector2(x - 1, y), layer_id_tile_map_layer_setup, wall_atlas)
			if y == -height/2.0: tile_map_layer_setup.set_cell(Vector2(x, y), layer_id_tile_map_layer_setup, wall_atlas)
			if x == height/2.0 - 1: tile_map_layer_setup.set_cell(Vector2(x + 1, y), layer_id_tile_map_layer_setup, wall_atlas)
			if y == height/2.0 - 1: tile_map_layer_setup.set_cell(Vector2(x, y + 1), layer_id_tile_map_layer_setup, wall_atlas)
				
			var noise_val: float = noise.get_noise_2d(x, y)
			cell_array.append(noise_val)
			var biome_nosie_val: float = biome_noise.get_noise_2d(x, y)
			biome_cell_array.append(biome_nosie_val)
	highest = cell_array.max()
	lowest = cell_array.min()
	biome_highest = biome_cell_array.max()
	biome_lowest = biome_cell_array.min()
	
	for x: float in range(-width/2.0, width/2.0):
		for y: float in range(-height/2.0, height/2.0):
			# normalise the value to within the max
			var noise_val: float = lerp(0.0, highest, noise.get_noise_2d(x, y))
			var biome_noise_val: float = lerp(0.0, biome_highest, biome_noise.get_noise_2d(x, y))
			if noise_val < 0.0:
				if noise_val >= -0.02:
					blue_tiles_0.append(Vector2(x,y))
				else:
					blue_tiles_1.append(Vector2(x,y))
					# walk on the ocean, see if i care
					#tile_map_layer_setup.set_cell(Vector2(x, y), layer_id_tile_map_layer_setup, wall_atlas)
					
			elif noise_val >= 0.0 and noise_val < 0.03:
				if noise_val <= 0.0185:
					yellow_tiles_0.append(Vector2(x,y))
					_chance_place_decor(x, y, "beach", 0.05)
				elif noise_val > 0.0185 and noise_val <= 0.025:
					yellow_tiles_1.append(Vector2(x,y))
				elif noise_val > 0.025:
					yellow_tiles_2.append(Vector2(x,y))
				#elif noise_val > 0.075:
					#yellow_tiles_3.append(Vector2(x,y))
					
			elif noise_val >= 0.03:
				if noise_val <= 0.075:
					if biome_noise_val > biome_threshold_brown and biome_noise_val < biome_threshold_purple:
						brown_tiles_0.append(Vector2(x,y))
						_chance_place_decor(x, y, "brown", 0.75)
						_chance_place_tree(x, y, biome_noise_val, 0.003)
					elif biome_noise_val > biome_threshold_purple:
						purple_tiles_0.append(Vector2(x,y))
						_chance_place_decor(x, y, "crystal")
						_chance_place_tree(x, y, biome_noise_val)
					else:
						green_tiles_0.append(Vector2(x,y))
						_chance_place_decor(x, y, "grass")
						_chance_place_tree(x, y, biome_noise_val)
				elif noise_val > 0.075 and noise_val <= 0.125:
					if biome_noise_val > biome_threshold_brown and biome_noise_val < biome_threshold_purple:
						brown_tiles_1.append(Vector2(x,y))
						_chance_place_decor(x, y, "brown", 0.75)
						_chance_place_tree(x, y, biome_noise_val, 0.002)
					elif biome_noise_val > biome_threshold_purple:
						purple_tiles_1.append(Vector2(x,y))
						_chance_place_decor(x, y, "crystal")
						_chance_place_tree(x, y, biome_noise_val)
					else:
						green_tiles_1.append(Vector2(x,y))
						_chance_place_decor(x, y, "grass")
						_chance_place_tree(x, y, biome_noise_val)
				elif noise_val > 0.125 and noise_val <= 0.175:
					if biome_noise_val > biome_threshold_brown and biome_noise_val < biome_threshold_purple:
						brown_tiles_2.append(Vector2(x,y))
						_chance_place_decor(x, y, "brown", 0.75)
						_chance_place_tree(x, y, biome_noise_val, 0.002)
					elif biome_noise_val > biome_threshold_purple:
						purple_tiles_2.append(Vector2(x,y))
						_chance_place_decor(x, y, "crystal")
						_chance_place_tree(x, y, biome_noise_val)
					else:
						green_tiles_2.append(Vector2(x,y))
						_chance_place_decor(x, y, "grass")
						_chance_place_tree(x, y, biome_noise_val)
				elif noise_val > 0.175:
					if biome_noise_val > biome_threshold_brown and biome_noise_val < biome_threshold_purple:
						brown_tiles_3.append(Vector2(x,y))
						_chance_place_decor(x, y, "brown", 0.75)
						_chance_place_tree(x, y, biome_noise_val, 0.002)
					elif biome_noise_val > biome_threshold_purple:
						purple_tiles_3.append(Vector2(x,y))
						_chance_place_decor(x, y, "crystal")
						_chance_place_tree(x, y, biome_noise_val)
					else:
						green_tiles_3.append(Vector2(x,y))
						_chance_place_decor(x, y, "grass")
						_chance_place_tree(x, y, biome_noise_val)
			elif noise_val > 0.3:
				if biome_noise_val > biome_threshold_brown and biome_noise_val < biome_threshold_purple:
					brown_tiles_3.append(Vector2(x,y))
					_chance_place_decor(x, y, "grass")
					_chance_place_tree(x, y, biome_noise_val)
				elif biome_noise_val > biome_threshold_purple:
					purple_tiles_3.append(Vector2(x,y))
					_chance_place_decor(x, y, "crystal")
					_chance_place_tree(x, y, biome_noise_val)
				else:
					green_tiles_3.append(Vector2(x,y))
					_chance_place_decor(x, y, "grass")
					_chance_place_tree(x, y, biome_noise_val)
			
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
	
	tile_map_layer.set_cells_terrain_connect(brown_tiles_0, terrain_brown_int, 0)
	tile_map_layer.set_cells_terrain_connect(brown_tiles_1, terrain_brown_int, 1)
	tile_map_layer.set_cells_terrain_connect(brown_tiles_2, terrain_brown_int, 2)
	tile_map_layer.set_cells_terrain_connect(brown_tiles_3, terrain_brown_int, 3)
	
	tile_map_layer.set_cells_terrain_connect(ocean_tiles_0, terrain_ocean_int, 0)
	tile_map_layer.set_cells_terrain_connect(ocean_tiles_1, terrain_ocean_int, 1)
	return true

func _chance_spawn_item(x: float, y: float, _biome_noise_val: float) -> void:
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
	elif _biome == "beach":
		layer = 2
	elif _biome == "brown":
		layer = 3
	if randf() < _chance: 
		var tile: int
		if _tile_limits != []:
			tile = _tile_limits.pick_random()
		else:
			tile = randi_range(0, 3)
		tile_map_layer_decor.set_cell(Vector2(x, y), layer, Vector2i(tile, 0))

func _chance_place_tree(x: float, y: float, _biome_noise_val: float, _chance: float = 0.2, _tile_limits: Array = []) -> void:
	var trees: Array[Vector2] = [ ]
	var trees_y: int = 0
	if _biome_noise_val > biome_threshold_brown and _biome_noise_val < biome_threshold_purple:
		trees_y = 6
		trees = [
			Vector2(0,trees_y),
		]
	elif _biome_noise_val > biome_threshold_purple:
		trees_y = 3
		trees = [
			Vector2(0,trees_y),
			Vector2(2,trees_y),
		]
	else:
		trees_y = 0
		trees = [
			Vector2(0,trees_y),
			Vector2(2,trees_y),
		]
	var layer: int = 0
	if randf() < _chance: 
		tile_map_layer_trees.set_cell(Vector2(x, y), layer, trees.pick_random())
