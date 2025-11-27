extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_sprite: Sprite2D = $Control/TextureRectHand/ItemSprite
@onready var label_item_name: Label = $Control/PanelContainer/LabelItemName
@onready var label_item_description: RichTextLabel = $Control/PanelContainer2/LabelItemDescription

@onready var item_sprite_previous: Sprite2D = $Control/TextureRectHand/ItemPrevious
@onready var item_sprite_next: Sprite2D = $Control/TextureRectHand/ItemNext
@onready var item_next_backing: TextureRect = $Control/TextureRectHand/ItemNextBacking
@onready var item_previous_backing: TextureRect = $Control/TextureRectHand/ItemPreviousBacking
@onready var item_sprite_backing: TextureRect = $Control/TextureRectHand/ItemSpriteBacking

var is_active: bool = false

var selected_item_index: int = 0:
	set(_index):
		if _index > inventory.size() - 1: _index = 0
		elif _index < 0: _index = inventory.size() - 1
		selected_item_index = _index
		_setup()
		
var inventory: Array[Dictionary] = [
	#{
		#name = "teledoggg",
		#description = "some kind of televised doggg",
		#sprite_menu = "res://gui/inventory/teledog.png",
		#sprite_game = "res://gui/inventory/teledog.png"
	#},
	#{
		#name = "orange fella",
		#description = "some kind of orange fella",
		#sprite_menu = "res://npcs/npc_orange/sprites/orang_idle.png",
		#sprite_game = "res://npcs/npc_orange/sprites/orang_idle.png"
	#},
	##{
		##name = "car",
		##description = "some kind of car",
		##sprite_menu = "res://npcs/npc_car/sprites/car.png",
		##sprite_game = "res://npcs/npc_car/sprites/car.png"
	##},
]

func _ready() -> void:
	#add_item(
		#"car",
		#"some kind of car",
		#"res://npcs/npc_car/sprites/car.png",
		#"res://npcs/npc_car/sprites/car.png"
	#)
	_setup()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if DialogueSystem.is_active:
			return
		if PauseMenu.is_active:
			return
		if ReputationManager.is_active:
			return
		if LevelManager.is_transitioning:
			return
		for ui: Node in get_tree().get_nodes_in_group("temp_ui"):
			if ui.visible:
				return
		if visible:
			_hide_inventory()
		else:
			_show_inventory()
			
	if event.is_action_pressed("pause"):
		if is_active:
			_hide_inventory()
			get_viewport().set_input_as_handled()
			
	if event.is_action_pressed("left"):
		#animation_player.play("change")
		#await animation_player.animation_finished
		selected_item_index -= 1
	elif event.is_action_pressed("right"):
		#animation_player.play("change")
		#await animation_player.animation_finished
		selected_item_index += 1
	
	if event.is_action_pressed("test"):
		add_item(
		"car",
		"some kind of car",
		"res://npcs/npc_car/sprites/car.png",
		"res://npcs/npc_car/sprites/car.png"
		)


func _show_inventory() -> void:
	is_active = true
	_setup()
	get_tree().paused = true
	show()
	animation_player.play("enter")


func _setup() -> void:
	if inventory.is_empty():
		label_item_name.text = "empty..."
		label_item_description.text = "y'got nothing."
		item_sprite.hide()
		item_sprite_previous.hide()
		item_sprite_next.hide()
		item_next_backing.hide()
		item_previous_backing.hide()
		item_sprite_backing.hide()
		return
	
	item_sprite.show()
	item_sprite_backing.show()
		
	if selected_item_index > inventory.size() + 1:
		selected_item_index = 0
		
	var selected_item: Dictionary = inventory[selected_item_index]
	label_item_name.text = selected_item.name
	label_item_description.text = selected_item.description
	item_sprite.texture = load(selected_item.sprite_menu)
	
	if inventory.size() > 1:
		
		item_sprite_previous.show()
		item_sprite_next.show()
		item_next_backing.show()
		item_previous_backing.show()
	
		var previous_index: int = selected_item_index - 1
		var previous_item: Dictionary = inventory[previous_index]
		print(previous_item)
		item_sprite_previous.texture = load(previous_item.sprite_menu)
		
		var next_index: int = selected_item_index + 1
		if next_index > inventory.size() - 1: next_index = 0
		var next_item: Dictionary = inventory[next_index]
		item_sprite_next.texture = load(next_item.sprite_menu)


func _hide_inventory() -> void:
	is_active = false
	animation_player.play("leave")
	await animation_player.animation_finished
	hide()
	get_tree().paused = false


func add_item(
	_item_name: String, 
	_item_description: String, 
	_item_sprite_menu: String, 
	_item_sprite_game: String
	) -> void:
		
	var new_item: Dictionary = {}
	new_item.name = _item_name
	new_item.description = _item_description
	new_item.sprite_menu = _item_sprite_menu
	new_item.sprite_game = _item_sprite_game
	#print(new_item)
	print(inventory)
	print()
	inventory.append(new_item)
	

func remove_item(_item: String) -> void:
	for i: int in inventory.size():
		if inventory[i].name == _item:
			inventory.remove_at(i)
