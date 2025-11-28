class_name NPCResource extends Resource

@export var npc_name: String = "[DEFAULT_NAME]"
@export var npc_portrait: CompressedTexture2D = load("res://gui/dialogue_system/sprites/portrait-white.png")
@export var npc_name_sprite: CompressedTexture2D = load("res://npcs/npc_blue/sprites/blue_dance_sheet.png")
@export_multiline var npc_font_bbcode: String = "{text}"
@export var bubble_indexes: Array[int] = [0, 1, 2, 3, 4]
