extends Attack

func play(beat: int):
	pulseCam()
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(get_slot().id))/12.0)
	Sounds.play_sound("snare", -5.0, "Music", 0.0, pitch) 
	var angles = [-15, 0, 15]
	for angle_deg in angles:
		var dir = G.main.player.get_target_dir().rotated(deg_to_rad(angle_deg))
		G.spawn_bullet(self, bullet_scene, G.main.player.global_position, dir, damage + bonus_damage)
	
	
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
