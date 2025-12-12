extends Attack

func before_play(beat: int):
	var attack = G.main.player.grid.get_slot(get_slot().get_index_of_slot()[1]-1,get_slot().get_index_of_slot()[0]).get_attack()
	if attack:
		damage = attack.damage
		bonus_damage = attack.bonus_damage
		t_name = attack.t_name
		attack.before_play(beat)
	bonus_damage = 0
	

func play(beat: int):
	
	
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(beat))/12.0)
	Sounds.play_sound("hat", 0.0, "Music", 0.0, pitch) 
	
	await get_tree().create_timer(0.07).timeout
	var attack = G.main.player.grid.get_slot(get_slot().get_index_of_slot()[1]-1,get_slot().get_index_of_slot()[0]).get_attack()
	if attack:
		attack.bonus_damage += bonus_damage
		attack.play(beat)
	
	
	
	
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
