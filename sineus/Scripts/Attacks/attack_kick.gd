extends Attack


func play(beat: int):
	pulseCam()
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(beat)-6)/12.0)
	Sounds.play_sound("kick", 0.0, "Music", 0.0, pitch) 
	G.spawn_bullet(self, preload("res://Scenes/projectiles/player_bullet_aoe.tscn"), G.main.player.global_position, G.main.player.global_position.direction_to(G.main.player.get_target_dir()), damage+bonus_damage)
	
	
func id_to_note(id):
	match id:
		0: return 1
		1: return 1
		2: return 4
		3: return 4
		4: return 3
		5: return 3
		6: return 1
		7: return 1
