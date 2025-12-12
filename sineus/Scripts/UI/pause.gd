extends Control

func show_pause():
	get_tree().paused = true
	var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	return_tween.tween_property(self, "position", Vector2(0,0), 0.2)

func _on_button_play_pressed() -> void:
	get_tree().paused = false
	var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	return_tween.tween_property(self, "position", Vector2(0,-2000), 0.2)
	


func _on_button_play_2_pressed() -> void:
	$Buttons.visible = false
	$Options.visible = true
	
func _on_button_play_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	
