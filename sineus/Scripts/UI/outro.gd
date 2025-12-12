extends Node2D

func _ready() -> void:
	$CanvasLayer/Control/VideoStreamPlayer.finished.connect(
		func():
		G.watchedCutscene = true
		get_tree().change_scene_to_file('res://Scenes/UI/main_menu.tscn')
	)
	
