extends Attack


func play(beat: int):
	pulseCam()
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(beat))/12.0)
	Sounds.play_sound("clap", -4.0, "Music", 0.0, pitch) 
	for i in 4:
		var angle = deg_to_rad(360.0 / 4 * i)
		var dir = Vector2.RIGHT.rotated(angle)
		G.spawn_bullet(self, bullet_scene, G.main.player.global_position, dir, damage+bonus_damage)
	
	
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
