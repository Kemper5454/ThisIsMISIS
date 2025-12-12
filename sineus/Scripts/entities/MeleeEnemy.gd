extends Enemy
class_name MeleeEnemy


@export_category('Melee Enemy')
@export var attack_cooldown : float = 1
@export var damage : float = 5

@onready var cooldown_timer := Timer.new()




func _ready() -> void:
	super()
	
	add_child(cooldown_timer)
	cooldown_timer.wait_time = attack_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.start(0)


func _process(delta: float) -> void:
	super(delta)
	#print(cooldown_timer.time_left)
	

func attack():
	super()
	if cooldown_timer.time_left<=0:
		
		
		var to_target := target.global_position - global_position
		if to_target.length()<=chase_dist:
			highlight()
			target.take_damage(damage)
			cooldown_timer.start()
		
			


		
		

func hunt_down():
	super()
				



func _update_animation(_delta: float) -> void:
	super(_delta)

	
	
	
