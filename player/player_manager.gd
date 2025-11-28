extends Node

const PLAYER: PackedScene = preload("res://player/player.tscn")

var player: Player
var player_spawned: bool = false

var followers: Array[Resource] = [
	#"res://npcs/npc_blue/sprites/blue_dance_sheet.png",
	#"res://npcs/npc_green/sprites/green_dance_sheet.png",
	#"res://npcs/npc_orange/sprites/orang_idle_sheet.png",
	#"res://npcs/npc_hand/npc_hand_walk_sheet2.png"
	]
var desired_seed: String

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos


func set_as_parent(_parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)


func unparent_player(_parent: Node2D) -> void:
	_parent.remove_child(player)
