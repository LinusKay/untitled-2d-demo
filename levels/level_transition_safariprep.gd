@tool
class_name LevelTransitionSafariPrep extends LevelTransition

@export var popup_menu_friend_select: CanvasLayer
@export var popup_menu_location_input: CanvasLayer


func _ready() -> void:
	super()
	popup_menu_friend_select.friend_chosen.connect(_on_friend_chosen)
	popup_menu_location_input.seed_selected.connect(_on_seed_selected)


func _player_entered(_player: Node2D) -> void:
	print(name, "player entered safari prep")
	#popup_menu_friend_select.show()
	popup_menu_location_input.show()


func _on_seed_selected() -> void:
	popup_menu_friend_select.show()

func _on_friend_chosen() -> void:
	LevelManager.load_new_level(level, target_transition_area, _get_offset())
