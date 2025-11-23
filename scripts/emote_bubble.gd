class_name EmoteBubble extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var offset: int = 5
@export var frame: int = 3

const BUBBLE_SCENE: PackedScene = preload("res://scenes/emote_bubble.tscn")

#var spread: bool = true

func _ready() -> void:
	sprite.frame = frame
	_set_position()
	animation_player.play("lifetime")
	animation_player.animation_finished.connect(func(_anim: String) -> void: queue_free())
	#if spread: _ping()


func _set_position() -> void:
	var parent: Node2D = get_parent()
	if parent.get_node("Sprite2D") != null:
		var bubbler_sprite: Sprite2D = parent.get_node("Sprite2D")
		var texture_height: int = bubbler_sprite.texture.get_height()
		var pos_y: float = parent.global_position.y - (texture_height / 2.0) * bubbler_sprite.scale.y
		global_position = Vector2(parent.global_position.x, pos_y - offset)
	else:
		var pos_x: float = parent.global_position.x
		var pos_y: float = parent.global_position.y
		global_position = Vector2(pos_x, pos_y)


#func _ping() -> void:
	#var npcs: Array[CharacterBody2D] = []
	#for child: Node in get_tree().get_nodes_in_group("npc"):
		#if child is CharacterBody2D:
			#npcs.append(child)
	#npcs.sort_custom(_sort_by_distance_to_player)
	#if npcs.size() == 0:
		#return
	#var closest: CharacterBody2D = npcs[0]
	#var new_bubble: EmoteBubble = BUBBLE_SCENE.instantiate()
	#new_bubble.spread = false
	#closest.add_child(new_bubble)

#func _sort_by_distance_to_player(char1: CharacterBody2D, char2: CharacterBody2D) -> bool:
	#var char1_to_player: float = PlayerManager.player.global_position.distance_to(char1.global_position)
	#var char2_to_player: float = PlayerManager.player.global_position.distance_to(char2.global_position)
	#return char1_to_player < char2_to_player
