extends Control

var is_fullscreen: bool = false

var volume_music: int = 0

func _ready() -> void:
	$VolumeValue.text = "Музыка:\n%s" % str(volume_music+1)
	$VolumeValueSFX.text = "Звуки:\n%s" % str(volume_sfx+1)

func _on_volume_up_pressed() -> void:
	if volume_music < 12:
		volume_music+=1
		AudioServer.set_bus_volume_db(2, volume_music)
	$VolumeValue.text = "Музыка:\n%s" % str(volume_music+1)

func _on_volume_down_pressed() -> void:
	if volume_music > -24:
		volume_music-=1
		AudioServer.set_bus_volume_db(2, volume_music)
	else:
		AudioServer.set_bus_volume_db(2, -80)
	$VolumeValue.text = "Музыка:\n%s" % str(volume_music+1)

var volume_sfx: int = 0

func _on_sfx_up_pressed() -> void:
	if volume_sfx < 12:
		volume_sfx+=1
		AudioServer.set_bus_volume_db(1, volume_sfx)
	$VolumeValueSFX.text = "Звуки:\n%s" % str(volume_sfx+1)
	Sounds.play_sound("cell",0,"SFX",0,1.0)

func _on_sfx_down_pressed() -> void:
	if volume_sfx > -24:
		volume_sfx-=1
		AudioServer.set_bus_volume_db(1, volume_sfx)
	else:
		AudioServer.set_bus_volume_db(1, -80)
	$VolumeValueSFX.text = "Звуки:\n%s" % str(volume_sfx+1)
	Sounds.play_sound("cell",0,"SFX",0,1.0)

func _on_button_close_pressed() -> void:
	get_parent().get_node("Buttons").visible = true
	visible = false


func _on_button_fullscreen_pressed() -> void:
	$ButtonFullscreen.position.y = -500
	$ButtonWindowed.position.y = 160
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		


func _on_button_windowed_pressed() -> void:
	$ButtonFullscreen.position.y = 160
	$ButtonWindowed.position.y = -500
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
