extends Node2D

#func _ready() -> void:
	#$Music.play()
	#$Music.pitch_scale = randf_range(0.8,1.2)
	
func stop_music():
	$Music.stop()
	
func _on_music_finished() -> void:
	$Music.pitch_scale = randf_range(0.8,1.2)

func set_music(sound_name: String):
	$Music.stream = load("res://Assets/Sounds/" + sound_name + ".ogg")
	$Music.play()

func play_sound(sound_name: String, volume: float = 0.0, bus: String = "Master", pitch_offset: float = 0.0, pitch: float = 1.0):
	sound_name = "res://Assets/Sounds/" + sound_name + ".ogg"
	var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio)
	new_audio.bus = bus
	new_audio.stream = load(sound_name)
	new_audio.volume_db = volume
	if pitch_offset != 0.0:
		pitch += randf_range(-pitch_offset, pitch_offset)
	new_audio.pitch_scale = abs(pitch)
	new_audio.play()
	delete_sound(new_audio)
	return new_audio

func play_sound_at(where, sound_name: String, volume: float = 0.0, bus: String = "Master", pitch_offset: float = 0.0, pitch: float = 1.0):
	sound_name = "res://Assets/Sounds/" + sound_name + ".ogg"
	var new_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	if where is Vector2:
		G.main.add_child(new_audio)
		new_audio.global_position = where
	else:
		add_child(new_audio)
	new_audio.bus = bus
	new_audio.stream = load(sound_name)
	new_audio.volume_db = volume
	new_audio.max_distance = 100 * (volume+80)/10
	new_audio.panning_strength = 0.2
	if pitch_offset != 0.0:
		pitch += randf_range(-pitch_offset, pitch_offset)
	new_audio.pitch_scale = abs(pitch)
	new_audio.play()
	delete_sound(new_audio)
	return new_audio
	
func delete_sound(sound):
	if sound: 
		var sound_len = sound.stream.get_length() + 0.7
		await get_tree().create_timer(sound_len).timeout 
	if sound:sound.queue_free()
	
