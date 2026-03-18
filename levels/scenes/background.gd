extends CanvasLayer

@export var background_day: CompressedTexture2D
@export var background_noon: CompressedTexture2D
@export var background_night: CompressedTexture2D
@onready var texture_rect: TextureRect = $Control/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeManager.time_changed.connect(setup_time_background)
	setup_time_background()


func setup_time_background() -> void:
	print(name + ": setup_time_background")
	if background_day:
		var time: int = TimeManager.get_time()
		if time < TimeManager.time_blocks.TIME_NOON:
			texture_rect.texture.diffuse_texture = background_day
		elif time >= TimeManager.time_blocks.TIME_NOON and time < TimeManager.time_blocks.TIME_NIGHT:
			if background_noon:
				texture_rect.texture.diffuse_texture = background_noon
			else:
				texture_rect.texture.diffuse_texture = background_day
		elif time >= TimeManager.time_blocks.TIME_NIGHT:
			if background_night:
				texture_rect.texture.diffuse_texture = background_night
