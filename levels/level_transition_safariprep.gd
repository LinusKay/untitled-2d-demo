@tool
class_name LevelTransitionSafariPrep extends LevelTransition

@export var popup_menu: CanvasLayer


func _ready() -> void:
	super()
	popup_menu.friend_chosen.connect(_on_friend_chosen)


func _player_entered(_player: Node2D) -> void:
	print(name, "player entered safari prep")
	popup_menu.show()


func _on_friend_chosen() -> void:
	LevelManager.load_new_level(level, target_transition_area, _get_offset())
