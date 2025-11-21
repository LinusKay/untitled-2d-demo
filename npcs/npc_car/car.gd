extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var persistent_data_car: PersistentDataHandler = $PersistentDataCar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var driving: bool = false

@export var driver: CharacterBody2D
var driver_sprite: Sprite2D

@export var driver_pos_offset: Vector2 = Vector2(0,7)


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	if driving:
		_driver_offboard()
	else:
		var player: Player = get_tree().get_first_node_in_group("player")
		_driver_onboard(player)


func _process(_delta: float) -> void:
	if driving:
		animation_player.current_animation = "drive"
		global_position = driver.global_position + driver_pos_offset
		scale.x = sign(driver_sprite.scale.x)
		driver.z_index = z_index
	else:
		animation_player.current_animation = "idle"


func _driver_onboard(player: Player) -> void:
	driver = player
	driver_sprite  = driver.get_node("Sprite2D")
	collision_shape_2d.disabled = true
	driving = true
	driver.car_enter.emit()


func _driver_offboard() -> void:
	collision_shape_2d.disabled = false
	driver.car_exit.emit()
	driving = false
	driver = null


func _unhandled_input(event: InputEvent) -> void:
	if driving:
		if event.is_action_pressed("car_horn"):
			audio_stream_player.play()
