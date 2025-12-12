extends Attack

func play(beat: int):
	var slot = G.main.player.grid.get_slot(get_slot().get_index_of_slot()[1],get_slot().get_index_of_slot()[0]+1)
	if slot:
		var attack = slot.get_attack()
		if attack and ["Снейр","Хай-хэт"].has(attack.t_name):
			attack.bonus_damage += attack.damage + attack.bonus_damage
	
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(get_slot().id))/12.0)
	Sounds.play_sound("ophat", -10.0, "Music", 0.0, pitch) 
	G.spawn_bullet(self, bullet_scene, G.main.player.global_position, G.main.player.get_target_dir(),damage+bonus_damage)
	
	
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
