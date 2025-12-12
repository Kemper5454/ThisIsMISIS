extends Attack

func play(beat: int):
	Sounds.play_sound("reverse", -10.0, "Music", 0.0, 1) 
	var slot = G.main.player.grid.get_slot(get_slot().get_index_of_slot()[1],get_slot().get_index_of_slot()[0]-1)
	if slot:
		var attack = slot.get_attack()
		if attack:
			attack.bonus_damage += 2
			attack.play(beat+1)
	
			
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
