extends Control

var id: int

func add_attack(attack):
	if !attack.get_parent():
		$Storage.add_child(attack)
	else:
		if get_attack():
			var prev_attack = get_attack()
			prev_attack.global_position = attack.prev_pos
			prev_attack.reparent(attack.get_parent())
		attack.reparent($Storage,false)

func get_attack():
	if $Storage.get_child_count()>0:
		return $Storage.get_child(0)
		
func get_index_of_slot():
	return [get_index(), get_parent().get_index()]
