@tool
class_name DialogueSystemNode extends CanvasLayer

signal finished

@onready var dialogue_ui: Control = $DialogueUI
@onready var content_label: RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogueUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogueUI/PortraitBorder/PortraitBack/PortraitSprite
@onready var dialogue_progress_indicator: PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label: Label = $DialogueUI/DialogueProgressIndicator/Label
@onready var name_sprite: Sprite2D = $DialogueUI/NameSprite
@onready var name_sprite_animation_player: AnimationPlayer = $DialogueUI/NameSprite/AnimationPlayer


var is_active: bool = false

var dialogue_items: Array[DialogueItem]
var dialogue_item_index: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	hide_dialogue()


func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if (
		event.is_action_pressed("interact") or
		event.is_action_pressed("ui_accept")
	):
		dialogue_item_index += 1
		if dialogue_item_index < dialogue_items.size():
			start_dialogue()
		else:
			hide_dialogue()


func show_dialogue(_items: Array[DialogueItem]) -> void:
	is_active = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogue_items = _items
	dialogue_item_index = 0
	get_tree().paused = true
	#await get_tree().process_frame # needed ?
	start_dialogue()


func hide_dialogue() -> void:
	is_active = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()


func start_dialogue() -> void:
	show_dialogue_button_indicator(true)
	var _item: DialogueItem = dialogue_items[dialogue_item_index]
	set_dialogue_data(_item)
	

func set_dialogue_data(_item: DialogueItem) -> void:
	if _item is DialogueText:
		content_label.text = _item.text
		
	# default values will be displayed if no npc info found
	if _item.npc_info:
		name_label.text = _item.npc_info.npc_name
		portrait_sprite.texture = _item.npc_info.npc_portrait
		name_sprite.texture = _item.npc_info.npc_name_sprite


func show_dialogue_button_indicator(_is_visible: bool) -> void:
	dialogue_progress_indicator.visible = _is_visible
	if dialogue_item_index + 1 < dialogue_items.size():
		dialogue_progress_indicator_label.text = "NEXT"
	else:
		dialogue_progress_indicator_label.text = "END"
