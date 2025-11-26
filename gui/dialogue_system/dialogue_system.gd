@tool
class_name DialogueSystemNode extends CanvasLayer

signal finished

@onready var dialogue_ui: Control = $DialogueUI
@onready var content_label: RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogueUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogueUI/PortraitSprite
@onready var dialogue_progress_indicator: PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label: Label = $DialogueUI/DialogueProgressIndicator/Label
@onready var name_sprite: Sprite2D = $DialogueUI/NameSprite
@onready var name_sprite_animation_player: AnimationPlayer = $DialogueUI/NameSprite/AnimationPlayer
@onready var bonus_image: TextureRect = $DialogueUI/BonusImage
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bonus_image_animation_player: AnimationPlayer = $DialogueUI/BonusImage/AnimationPlayer
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogueUI/AudioStreamPlayer
@onready var v_box_choices: VBoxContainer = $DialogueUI/VBoxChoices


var is_active: bool = false
var accept_input: bool = true
var waiting_for_choice: bool = false

var dialogue_items: Array[DialogueItem]
var dialogue_item_index: int = 0

var next_button_options: Array[String] = ["NEXT", "OK", "SURE", "WHATEVER", "UH HUH", "YUP", "MHM", "YE", "YA"]
var end_button_options: Array[String] = ["END", "BYE", "OK BYE", "CYA"]


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	hide_dialogue(true)
	SaveManager.game_loaded.connect(_on_game_load)


func _on_game_load() -> void:
	if dialogue_items.size() > 0:
		if dialogue_item_index < dialogue_items.size():
			show_dialogue(dialogue_items, dialogue_item_index)
			return
		return
	hide_dialogue(true)


func _unhandled_input(event: InputEvent) -> void:
	if is_active == false or accept_input == false:
		return
	if (
		event.is_action_pressed("interact") or
		event.is_action_pressed("ui_accept")
	):
		if waiting_for_choice == true:
			return
		else:
			_increase_item_index()
	


func _increase_item_index() -> void:
	dialogue_item_index += 1
	if dialogue_item_index < dialogue_items.size():
		start_dialogue()
	else:
		hide_dialogue()


func show_dialogue(_items: Array[DialogueItem], _index: int = 0) -> void:
	animation_player.play("start")
	is_active = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogue_items = _items
	dialogue_item_index = _index
	get_tree().paused = true
	#await get_tree().process_frame # needed ?
	start_dialogue()


func hide_dialogue(silent: bool = false) -> void:
	if not silent:
		animation_player.play("leave")
		if bonus_image.position.x < 500:
			bonus_image_animation_player.play("leave")
		await animation_player.animation_finished
	dialogue_items = []
	is_active = false
	v_box_choices.visible = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()


func start_dialogue() -> void:
	waiting_for_choice = false
	show_dialogue_button_indicator(true)
	var _item: DialogueItem = dialogue_items[dialogue_item_index]
	
	if _item is DialogueText:
		set_dialogue_text(_item)
	elif _item is DialogueChoice:
		set_dialogue_choice(_item)


func set_dialogue_choice(_item: DialogueChoice) -> void:
	v_box_choices.visible = true
	waiting_for_choice = true
	for child: Node in v_box_choices.get_children():
		child.queue_free()
	
	for i: int in _item.dialogue_branches.size():
		var _new_choice: Button = Button.new()
		_new_choice.text = _item.dialogue_branches[i].text
		_new_choice.pressed.connect(_on_dialogue_choice_select.bind(_item.dialogue_branches[i]))
		v_box_choices.add_child(_new_choice)
	
	await get_tree().process_frame # needed ?
	v_box_choices.get_child(0).grab_focus()
	

func _on_dialogue_choice_select(_item: DialogueBranch) -> void:
	v_box_choices.visible = false
	show_dialogue(_item.dialogue_items)
	pass


func set_dialogue_text(_item: DialogueText) -> void:
	# default values will be displayed if no npc info found
	timer.stop()
	if _item.npc_info:
		name_label.text = _item.npc_info.npc_name
		portrait_sprite.texture = _item.npc_info.npc_portrait
		name_sprite.texture = _item.npc_info.npc_name_sprite
		if _item.time > 0.0:
			accept_input = false
			timer.start(_item.time)
		
		content_label.text = _item.npc_info.npc_font_bbcode.replace("{text}", _item.text)
	else:
		content_label.text = _item.text
	
	if _item.bonus_image:
		bonus_image.texture = _item.bonus_image
		bonus_image.show()
		bonus_image_animation_player.play("start")
	else:
		if bonus_image.position.x < 499:
			bonus_image_animation_player.play("leave")
	
	if _item.sound:
		audio_stream_player.stream = _item.sound
		audio_stream_player.play()


func show_dialogue_button_indicator(_is_visible: bool) -> void:
	dialogue_progress_indicator.visible = _is_visible
	if dialogue_item_index + 1 < dialogue_items.size():
		dialogue_progress_indicator_label.text = next_button_options.pick_random()
	else:
		dialogue_progress_indicator_label.text = end_button_options.pick_random()


# allow opening links in textboxes
func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


# allow selecting textbox next button with mouse
func _on_dialogue_progress_indicator_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			_increase_item_index()


func _on_timer_timeout() -> void:
	accept_input = true
	_increase_item_index()
