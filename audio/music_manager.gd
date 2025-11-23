extends Node

@export var current_track: AudioStream

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player.stream = current_track
	player.play()


func change_music(_new_track: AudioStream) -> void:
	if _new_track and _new_track != current_track:
		animation_player.play("fade_out")
		await animation_player.animation_finished
		player.stream = _new_track
		current_track = player.stream
		player.play()
		animation_player.play("fade_in")

func _on_fadeout_finish() -> void:
	#player.stream = current_track
	#player.play()
	animation_player.animation_finished.disconnect(_on_fadeout_finish)
	pass
	
