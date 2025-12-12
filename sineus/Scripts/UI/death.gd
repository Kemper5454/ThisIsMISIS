extends Control

var tween: Tween

func animate():
	if tween and tween.is_running(): tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
	tween.tween_property(self, "global_position:y", 0, 1.0)
	showText()

func showText():
	var scoretext = "Время жизни: %s
					Нанесено урона: %s
					Получено урона: %s
					Убито нежити: %s
					Опыта получено: %s"
	$Stats.text = scoretext % [str(G.seconds_to_hhmmss(int(G.main.time_passed))),str(G.main.player.damage_dealt),str(G.main.player.damage_received),str(G.main.player.enemies_killed),str(G.main.player.experience)]
	
func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	AudioServer.set_bus_volume_db(2,0)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	AudioServer.set_bus_volume_db(2,0)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
