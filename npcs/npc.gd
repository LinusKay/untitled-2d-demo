class_name NPC extends CharacterBody2D

signal direction_changed(new_direction: Vector2)

const DIR_4: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
const EMOTE_BUBBLE: PackedScene = preload("res://scenes/emote_bubble.tscn")
const MAIL_ONSCREEN_NOTIFIER_PATH: String = "res://npcs/mail_onscreen_notifier.tscn"

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: NPCStateMachine = $NPCStateMachine
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

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
		if audio_stream_player:
			if npc_info.voices.size() > 0:
				audio_stream_player.stream = npc_info.voices.pick_random()
				audio_stream_player.pitch_scale = randf_range(0.8, 1.1)
				audio_stream_player.play()


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


func set_awaiting_mail(_awaiting_mail: bool = true) -> void:
	if _awaiting_mail:
		npc_info.awaiting_mail = true
		if not has_node("VisibleOnScreenNotifier2D"):
			var onscreen_notif_resource: Resource = load(MAIL_ONSCREEN_NOTIFIER_PATH)
			var onscreen_notif: VisibleOnScreenNotifier2D = onscreen_notif_resource.instantiate()
			onscreen_notif.hide_onscreen = false
			onscreen_notif.allow_rotate = false
			if has_node("Sprite2D"):
				var sprite2d: Sprite2D = get_node("Sprite2D")
				onscreen_notif.position.y -= sprite2d.texture.get_height()
			add_child(onscreen_notif)
	else:
		if has_node("VisibleOnScreenNotifier2D"):
			get_node("VisibleOnScreenNotifier2D").queue_free()
			npc_info.awaiting_mail = false


func clear_dialogue() -> bool:
	if has_node("InteractionDialogue"):
		get_node("InteractionDialogue").clear_dialogue()
		return true
	return false


func set_dialogue(_dialogue_items: Array[DialogueItem]) -> bool:
	if has_node("InteractionDialogue"):
		get_node("InteractionDialogue").set_dialogue(_dialogue_items)
		return true
	return false
