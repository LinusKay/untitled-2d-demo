class_name FriendSelectOption extends TextureButton

@export var friend_select: FriendSelect
@export var npc_info: Resource

func _ready() -> void:
	texture_normal = npc_info.npc_portrait
	pressed.connect(_on_press)
	focus_entered.connect(_on_focus)
	focus_exited.connect(_on_unfocus)
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_leave)

func _on_press() -> void:
	print("pressedddd ", npc_info.npc_name)
	friend_select.on_friend_chosen(npc_info)


func _on_focus() -> void:
	modulate = "ffffffff"


func _on_unfocus() -> void:
	modulate = "ffffff95"


func _on_mouse_enter() -> void:
	grab_focus()


func _on_mouse_leave() -> void:
	pass
	
