@tool
class_name DialogueItem extends Node

@export var npc_info: NPCResource
@export var bonus_image: CompressedTexture2D
@export var time: float = 0.0
@export var sound: AudioStream


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	check_npc_data()


func check_npc_data() -> void:
	if npc_info == null:
		var parent: Node = self
		var _checking: bool = true
		while _checking == true:
			parent = parent.get_parent()
			if parent:
				if parent is NPC and parent.npc_info:
					npc_info = parent.npc_info
					_checking = false
			else:
				_checking = false
					
	pass
