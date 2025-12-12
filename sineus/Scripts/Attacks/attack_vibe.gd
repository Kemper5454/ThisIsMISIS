extends Attack

func play(beat: int):
	if get_tree().paused: return
	
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(beat)-12)/12.0)
	Sounds.play_sound("vibe", -10.0, "Music", 0.0, pitch) 
	
	var healed : bool = G.main.player.heal(1)
	if healed:
		Sounds.play_sound("plus_vibe", -10.0, "Music", 0.0, 1) 
	
	
func id_to_note(id):
	id = id%128
	
	match id:
		# 1 квадрат
		0: return 2
		1: return 2
		2: return 4
		3: return 7
		4: return 9
		5: return 9
		6: return 4
		7: return 9

		8: return 10
		9: return 5
		10: return 10
		11: return 2
		12: return 16
		13: return 12
		14: return 10
		15: return 9
				
		16: return 2
		17: return 10
		18: return 10
		19: return 2
		20: return 4
		21: return 4
		22: return 9
		23: return 4

		24: return 5
		25: return 5
		26: return 4
		27: return 8
		28: return 2
		29: return 10
		30: return 9
		31: return 5

		# 2 квадрат
		32: return 2
		33: return 2
		34: return 4
		35: return 7
		36: return 9
		37: return 9
		38: return 4
		39: return 9

		40: return 10
		41: return 5
		42: return 10
		43: return 2
		44: return 16
		45: return 12
		46: return 10
		47: return 9

		48: return 2
		49: return 10
		50: return 10
		51: return 2
		52: return 4
		53: return 4
		54: return 9
		55: return 4

		56: return 5
		57: return 5
		58: return 2
		59: return 5
		60: return 10
		61: return 9
		62: return 7
		63: return 5

		# 3 квадрат
		64: return 4
		65: return 4
		66: return 9
		67: return 10
		68: return 9
		69: return 9
		70: return 4
		71: return 5

		72: return 4
		73: return 4
		74: return 4
		75: return 5
		76: return 7
		77: return 5
		78: return 4
		79: return 2

		80: return 4
		81: return 4
		82: return 4
		83: return 5
		84: return 4
		85: return 4
		86: return 9
		87: return 10

		88: return 9
		89: return 2
		90: return 5
		91: return 7
		92: return 10
		93: return 2
		94: return 4
		95: return 2

		# 4 квадрат
		96: return 2
		97: return 2
		98: return 4
		99: return 4
		100: return 4
		101: return 9
		102: return 7
		103: return 5

		104: return 2
		105: return 2
		106: return 5
		107: return 5
		108: return 5
		109: return 9
		110: return 9
		111: return 5

		112: return 2
		113: return 2
		114: return 4
		115: return 4
		116: return 4
		117: return 9
		118: return 7
		119: return 5

		120: return 2
		121: return 4
		122: return 2
		123: return 9
		124: return 5
		125: return 4
		126: return 4
		127: return 4
