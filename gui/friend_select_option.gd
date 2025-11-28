class_name FriendSelectOption extends TextureButton

@export var friend_select: FriendSelect
@export var npc_info: Resource
@onready var audio_stream_player: AudioStreamPlayer2D = friend_select.get_node("AudioStreamPlayer2D")

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
	if npc_info.voices:
		audio_stream_player.stream = npc_info.voices.pick_random()
		audio_stream_player.pitch_scale = randf_range(0.8,1.1)
		audio_stream_player.play()


func _on_unfocus() -> void:
	modulate = "ffffff95"


func _on_mouse_enter() -> void:
	grab_focus()


func _on_mouse_leave() -> void:
	pass
	
