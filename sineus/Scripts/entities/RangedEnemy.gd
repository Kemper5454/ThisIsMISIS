extends Enemy
class_name RangedEnemy

@export_category('Ranged Enemy')
@export var bullet : PackedScene
@export var bullet_speed : float = 450
@export var attack_cooldown : float = 1
@export var damage : float = 3

@onready var cooldown_timer := Timer.new()

func _ready() -> void:
	super()
	
	add_child(cooldown_timer)
	cooldown_timer.wait_time = attack_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.start(0)

func attack():
	super()

	
	if cooldown_timer.time_left<=0:
		highlight()
		var to_target := target.global_position - global_position
		var shoot_dir : Vector2 = to_target.normalized()
		var b : Bullet = G.spawn_bullet(self,bullet,global_position,shoot_dir,damage)
		b.speed = bullet_speed
	
		cooldown_timer.start()
		#if to_target.length()<=chase_dist:
			
'''
var _cooldown : float = 0

func attack():
	super()
	if _cooldown>0:
		_cooldown -= _think_accum
		return
	
	_cooldown = attack_cooldown
	var to_target := target.global_position - global_position
	var dist : = target.global_position.distance_to(global_position)
	
	if dist>attack_dist:
		current_dir = to_target.normalized()
	else:
		current_dir = Vector2.ZERO
	
	var shoot_dir : Vector2 = to_target.normalized()
	#+ ( (dist/bullet.instantiate().speed)-1)*target.velocity.normalized()
	
	G.spawn_bullet(self,bullet,global_position,shoot_dir,damage)
	
		
		'''
		
		
