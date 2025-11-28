class_name NPC extends CharacterBody2D

signal direction_changed(new_direction: Vector2)

const DIR_4: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
const EMOTE_BUBBLE: PackedScene = preload("uid://d143re016yja2")

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: NPCStateMachine = $NPCStateMachine

@export var npc_info: NPCResource
#@export var rep: float = 1.0

var bubble_response_proximity: float = 75.0

var interaction_area: InteractionArea
var interaction_func: String

func _ready() -> void:
	state_machine.init(self)
	player = PlayerManager.player
	player.send_bubble.connect(_bubble_response)
	gather_interactibles()
	#if has_node("InteractionDialogue"):
		#interaction_area = get_node("InteractionDialogue")
		#interaction_area.interact = Callable(self, "_on_interact")

func _bubble_response() -> void:
	var player_distance: float = global_position.distance_to(player.global_position)
	if player_distance < bubble_response_proximity:
		#var rep: float = ReputationManager.get_reputation(name)
		var bubble: Node2D = EMOTE_BUBBLE.instantiate()
		bubble.frame = npc_info.bubble_indexes.pick_random()
		#if rep <= 0.0:
			#bubble.frame = 1
		#elif rep <= 1.0: 
			#bubble.frame = 2
		#elif rep <= 2.0:
			#bubble.frame = 3
		#elif rep > 2.0:
			#bubble.frame = 0
		add_child(bubble)

func gather_interactibles() -> void:
	for child: Node in get_children():
		if child is DialogueInteraction:
			child.player_interacted.connect(_on_player_interacted)
			child.finished.connect(_on_interaction_finished)


func _on_player_interacted() -> void:
	#print("interacting with ", name)
	pass


func _on_interaction_finished() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(_new_dir: Vector2) -> bool:
	direction = _new_dir
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
