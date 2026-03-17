class_name State_Walk extends State

@export var move_speed: float = 100.0

@onready var idle: State_Idle = $"../idle"
@onready var jump: State_Jump = $"../jump"
@onready var swim: Node = $"../swim"

# When player enters state
func enter() -> void:
	player.update_animation("walk")
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
		
	if player.check_water_depth() > 2:
		return swim
		
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("jump"):
		return jump
	return null



func footstep() -> void:
	var tilemaplayer: TileMapLayer = get_tree().get_first_node_in_group("tilemaplayer")
	if tilemaplayer:
		var tile_coord: Vector2 = tilemaplayer.local_to_map(tilemaplayer.to_local(player.global_position))
		if tilemaplayer.get_cell_tile_data(tile_coord):
			var tile_data_material: String = tilemaplayer.get_cell_tile_data(tile_coord).get_custom_data("tile_material")
			#if tile_data_material == "water":
				#var splash: CPUParticles2D = PARTICLES_SPLASH.instantiate()
				#splash.global_position = global_position
				#splash.emitting = true
				#get_parent().add_child(splash)
			if tile_data_material:
				var tile_data_sounds: Array = tilemaplayer.get_cell_tile_data(tile_coord).get_custom_data("step_sounds")
				if tile_data_sounds.size() > 0:
					var step_audio: AudioStream = load(tile_data_sounds.pick_random())
					if step_audio:
						var audio_stream_polyphonic: AudioStreamPlaybackPolyphonic = player.player_sound_footsteps.get_stream_playback()
						var stream_id: int = audio_stream_polyphonic.play_stream(step_audio)
						audio_stream_polyphonic.set_stream_pitch_scale(stream_id, randf_range(0.9,1.1))
