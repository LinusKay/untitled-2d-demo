extends CanvasLayer

@onready var label_rep_blue: Label = %LabelRepBlue
@onready var label_rep_green: Label = %LabelRepGreen
@onready var label_rep_orange: Label = %LabelRepOrange

@onready var bubble_icon_blue: Sprite2D = %BubbleIconBlue
@onready var bubble_icon_green: Sprite2D = %BubbleIconGreen
@onready var bubble_icon_orange: Sprite2D = %BubbleIconOrange

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_active: bool = false

var reputation: Dictionary = {
	NpcBlue = 1.0,
	NpcGreen = 3.0,
	NpcOrange = 1.0
}


func set_reputation(_npc_name: String, _new_rep: float) -> void:
	create_if_not_exist(_npc_name)
	reputation[_npc_name] = _new_rep


func get_reputation(_npc_name: String) -> float:
	if reputation.has(_npc_name):
		print("rep exists for ", _npc_name, ": ", reputation[_npc_name])
		return reputation[_npc_name]
	else:
		print("rep not found for ", _npc_name)
		return 1.0


func increase_reputation(_npc_name: String, _increase_amount: float) -> void:
	create_if_not_exist(_npc_name)
	reputation[_npc_name] += _increase_amount


func decrease_reputation(_npc_name: String, _decrease_amount: float) -> void:
	create_if_not_exist(_npc_name)
	reputation[_npc_name] -= _decrease_amount


func create_if_not_exist(_npc_name: String) -> void:
	if not reputation.has(_npc_name):
		reputation[_npc_name] = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rep"):
		if DialogueSystem.is_active:
			return
		if InventoryMenu.is_active:
			return
		if PauseMenu.is_active:
			return
		if LevelManager.is_transitioning:
			return
		for ui: Node in get_tree().get_nodes_in_group("temp_ui"):
			if ui.visible:
				return
		if visible:
			_hide_rep_ui()
		else:
			_show_rep_ui()
	
	if event.is_action_pressed("pause"):
		if is_active:
			_hide_rep_ui()
			get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("test"):
		increase_reputation("NpcBlue", 1.0)


func _show_rep_ui() -> void:
	is_active = true
	_update_ui()
	get_tree().paused = true
	visible = true
	animation_player.play("enter")


func _hide_rep_ui() -> void:
	is_active = false
	animation_player.play("leave")
	await animation_player.animation_finished
	get_tree().paused = false
	visible = false


func _update_ui() -> void:
	var rep_blue: float = reputation.NpcBlue
	var rep_green: float = reputation.NpcGreen
	var rep_orange: float = reputation.NpcOrange
	
	label_rep_blue.text = "rep: " + str(rep_blue)
	label_rep_green.text = "rep: " + str(rep_green)
	label_rep_orange.text = "rep: " + str(rep_orange)
	
	bubble_icon_blue.frame = _map_rep_bubble_frame(rep_blue)
	bubble_icon_green.frame = _map_rep_bubble_frame(rep_green)
	bubble_icon_orange.frame = _map_rep_bubble_frame(rep_orange)


func _map_rep_bubble_frame(_rep: float) -> int:
	if _rep <= 0.0: return 1
	elif _rep <= 1.0: return 2
	elif _rep <= 2.0: return 3
	elif _rep > 2.0: return 0
	else: return 4
