extends Control
class_name Attack

var init_scale: Vector2 = Vector2(1,1)

@export var t_name = "aboba"
@export_multiline var t_desc = "aboba2"
@export var has_tooltip: bool = true

signal selected()

@export var is_tonal: bool = true

var can_move: bool = true

var holding: bool = false
var prev_pos: Vector2

@export var damage: int = 1
var bonus_damage: int = 0

func pulseCam():
	var cam_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	cam_tween.tween_property(G.main.player.cam, "zoom", Vector2(0.91,0.91), 0.05)
	cam_tween.tween_property(G.main.player.cam, "zoom", Vector2(0.9,0.9), 0.1)

func _ready() -> void:
	init_scale = scale
	$Stars.visible = false

func get_slot():
	return get_parent().get_parent()

func _process(delta: float) -> void:
	$Damage.text = str(damage + bonus_damage)
	if holding and can_move:
		$Sprite2D.z_index = 3
		var mouse_pos = get_global_mouse_position()
		global_position = global_position.lerp(mouse_pos, 17 * delta)
		rotation = (mouse_pos.x - global_position.x)/200
	else:
		$Sprite2D.z_index = 2
		rotation = 0

func _on_button_button_up() -> void:
	if can_move:
		holding = false
		
		var move_to_pos: Vector2
		
		var slot_found = G.raycast_check(self, 4)
		if slot_found:
			move_to_pos = slot_found.global_position
			slot_found.add_attack(self)
		else:
			move_to_pos = prev_pos
			
		global_position = move_to_pos
		#var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
		#return_tween.tween_property(self, "global_position", move_to_pos, 0.1)
		AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale,0],[init_scale*1.1,0.1])
		
func _on_button_button_down() -> void:
	if can_move:
		selected.emit(self)
		holding = true
		prev_pos = global_position
		AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale*1.05,0],[init_scale,0.05])
		
var bullet_scene = preload("res://Scenes/projectiles/bullet.tscn")

func before_play(beat: int):
	bonus_damage = 0

func play(beat: int):
	var pitch = 1
	if is_tonal: 
		pitch = 2 ** ((id_to_note(beat)-12)/12.0)
	Sounds.play_sound("basicC", 1.0, "Music", 0.0, pitch) 
	G.spawn_bullet(self, bullet_scene, G.main.player.global_position, G.main.player.get_target_dir(),damage+bonus_damage)
	
	
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

func _on_button_mouse_entered() -> void:
	AM.jump($Sprite2D,Tween.TransitionType.TRANS_EXPO,[init_scale,0],[init_scale*1.1,0.1])
	$Stars.visible = true
	if has_tooltip: Tooltip.target = self

func _on_button_mouse_exited() -> void:
	AM.jump($Sprite2D,Tween.TransitionType.TRANS_EXPO,[init_scale*1.1,0],[init_scale,0.1])
	$Stars.visible = false
	if has_tooltip: Tooltip.target = null
