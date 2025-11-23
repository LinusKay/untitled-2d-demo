class_name Player extends CharacterBody2D

signal direction_changed(new_dir: Vector2)
@warning_ignore("unused_signal")
signal car_enter
@warning_ignore("unused_signal")
signal car_exit
@warning_ignore("unused_signal")
signal player_click

signal send_bubble

const DIR_4: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

const EMOTE_BUBBLE: PackedScene = preload("uid://d143re016yja2")


func _ready() -> void:
	state_machine.init(self)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("bubble"):
		var bubble: Node2D = EMOTE_BUBBLE.instantiate()
		add_child(bubble)
		send_bubble.emit()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move_and_slide()


func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir: Vector2 = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	if cardinal_direction == Vector2.LEFT: sprite.scale.x = -1
	elif cardinal_direction == Vector2.RIGHT: sprite.scale.x = 1

	return true


func update_animation(state: String) -> void:
	animation_player.play(state)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event .is_pressed() and event is InputEventMouseButton:
		player_click.emit()
