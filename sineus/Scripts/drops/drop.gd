extends Node2D
class_name Drop

@export_category('Modifies varible')
@export var modifies_varible : String  # ЭТО СВОЙСТВО БУДЕТ МОДИФИЦИРОВАНО ПРИ СБОРЕ ДРОПА
@export var value : float # СКОЛЬКО ПРИБАВИТСЯ

@export_category('Settings')
@export var sensivity_area : Area2D
@export var trail_line : Line2D


var player : Player

var speed : float = 500

func _ready() -> void:
	sensivity_area.body_entered.connect(detected_object)
	
	AM.appear(self,0.2)
	

var max_dist : float = 0
func _process(delta: float) -> void:
	if is_instance_valid(player):
		var to_player : = player.global_position - global_position
		var factor = delta * speed / max(to_player.length(), 1.0)  # closer → bigger factor
		global_position = lerp(global_position, player.global_position, clamp(factor, 0.0, 1.0))
		
		if trail_line:
			trail_line.points[1] = -to_player.normalized() * 50 * abs(to_player.length()/max_dist)
		
		if to_player.length()<30:
			player.set(modifies_varible,player.experience + value)
			player.on_drop_pickup(modifies_varible)
			queue_free()

func detected_object(body):
	if body is Player:
		player = body
		max_dist = (player.global_position - global_position).length()
