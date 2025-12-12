extends Node
class_name WaveNode

var RNG : = RandomNumberGenerator.new()
@export var mobs_in_wave : Array[PackedScene]
@export var min_amount_of_enemies : int
@export var max_amount_of_enemies : int
@export var _min_spawn_time : int
@export var _max_spawn_time : int
@export var _mob_health_multiplier : float = 1
@export var max_entities : int = 100

var entities : Array[Entity]

func _ready() -> void:
	RNG.randomize()

func add_enemies():
	if len(entities)>=max_entities: return
	
	for i in range(RNG.randi_range(min_amount_of_enemies,max_amount_of_enemies)):
		var mob : Enemy = G.spawn_object(mobs_in_wave.pick_random(),G.main.get_random_point_around_player(500))
		mob.health *= _mob_health_multiplier
		
		entities.append(mob)

func _process(delta: float) -> void:
	clear_up_dead()

func clear_up_dead():
	var new_entities_list : Array[Entity]
	for e in entities:
		if is_instance_valid(e):
			new_entities_list.append(e)
	
	entities = new_entities_list
		
func randomize_timer():
	#print(_min_spawn_time,' ',_max_spawn_time, ' ', max_amount_of_enemies, ' ', min_amount_of_enemies)
	return RNG.randf_range(_min_spawn_time,_max_spawn_time)
