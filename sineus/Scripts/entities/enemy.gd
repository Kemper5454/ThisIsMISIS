extends Entity
class_name Enemy

@export_category("Enemy")
@export var speed : float = 100
@export var detection_area: Area2D
#@export_range(0.05, 1.0, 0.05) var think_interval: float = 0.2

@export_category('Chasing')
@export var chase_dist : float = 150

@export_category('Animations')
@export var entity_sprite : Sprite2D
@export var flip_h_reversed : bool = false

@export var enable_sqeeze_during_movement : bool = false
@export var sqeeze_time : float = 0.5
@export var squeeze_multiplier_y : float = 0.8




@export_subgroup('Flags')
@export var can_think: bool = true
@export var can_be_stunned : bool = true
@export var no_stop_attacking : bool = false


'''
@export_subgroup('Wandering settings')
@export_range(0.0, 1.0, 0.01) var wander_chance: float = 0.3
@export_range(0.5, 5.0, 0.5) var wander_dir_time_min: float = 2.0
@export_range(0.5, 10.0, 0.5) var wander_dir_time_max: float = 7.0

@export_range(0.5, 5.0, 0.5) var min_idling_time : float = 2
@export_range(0.5, 5.0, 0.5) var max_idling_time : float = 5'''

@export_subgroup('Stun settings')
@export var stun_time : float = 0.5
@export var stun_knockback_power : float = 1

@export_category('Drops')
@export var Drops : Dictionary[PackedScene,int]

var target: CharacterBody2D

@onready var think_timer : = Timer.new()
var think_interval : float = G.think_interval

enum States { Idle, Chasing, Attacking, Stun, Knockback }
var state: int = States.Idle

#enum AnimStates { Idle, Damaged }
#var anim_state: int = AnimStates.Idle

var current_dir: Vector2 = Vector2.ZERO
'''
var steps: float = 0.0                    # Сколько секунд ещё идти в текущем направлении
var _think_accum: float = 0.0
var idling_time : float = 0'''

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	super()
	AM.appear(self)
	
	for l in range(1,6):
		set_collision_mask_value(l,false)
		set_collision_layer_value(l,false)
		
	set_collision_layer_value(2,true)
	set_collision_mask_value(1,true)
	set_collision_mask_value(2,true)
	set_collision_mask_value(3,true)
	set_collision_mask_value(5,true)
	
	_rng.randomize()
	
	add_child(think_timer)
	think_timer.wait_time = think_interval
	think_timer.timeout.connect( 
		func():
		if can_think:
			_think_tick()
			think_timer.start()
		)
	think_timer.start()

	if detection_area:
		detection_area.body_entered.connect(_on_detection_body_entered)
		#detection_area.body_exited.connect(_on_detection_body_exited)
	else:
		push_warning("Enemy.detection_area не назначена")
		
	if entity_sprite:
		normal_scale = entity_sprite.scale
	
	
		
		
	

	var notifier : = VisibleOnScreenNotifier2D.new()
	add_child(notifier)
	notifier.screen_entered.connect(func(): can_think = true)
	notifier.screen_exited.connect(func(): can_think = false)
	


func _process(delta: float) -> void:
	super(delta)
	_update_animation(delta)

func _physics_process(delta: float) -> void:
	super(delta)
	velocity = current_dir * speed + knockback_velocity
	
	if knockback_velocity:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,delta * 400)
	
	#move_and_collide(velocity * delta)
	move_and_slide()

func _think_tick() -> void:

	match state:
		States.Idle:
			current_dir = Vector2.ZERO
			
			if is_instance_valid(target):
				state = States.Chasing
				
		
		States.Chasing:
			
			if is_instance_valid(target):
				
				hunt_down()
			else:
				state = States.Idle
		
		States.Attacking:
			if !no_stop_attacking:
				current_dir = Vector2.ZERO
			else:
				current_dir = (target.global_position - global_position).normalized()
				
			if is_instance_valid(target):
				if global_position.distance_to(target.global_position)<=chase_dist:
					attack()
				else:
					state = States.Chasing
			else:
				state = States.Idle
			
		States.Stun:
			pass
		
	


				
				
		

func attack():
	pass		

func hunt_down():
	var to_target = target.global_position - global_position
	#print('Hunting down')
	if to_target.length()>0.01:
		if to_target.length()>chase_dist:
			current_dir = to_target.normalized()
		else:
			state = States.Attacking
	

func take_damage(damage: float, damage_from_dir : Vector2, knockback_power: float) -> void:
	if damage <= 0:
		return
	health = max(health - damage, 0)
	G.spawnDamageNumber(damage, global_position)
	G.main.player.damage_dealt += damage
	
	if health <= 0:
		_die()
		return
		
	Sounds.play_sound("damage",-18,"SFX",0.3,1.0)
	AM.shake(self, 0.3)
	
	if can_be_stunned and stun_time > 0:
		state = States.Stun
		apply_knockback(damage_from_dir, knockback_power)
		await get_tree().create_timer(stun_time).timeout
		state = States.Idle

var knockback_velocity: Vector2 = Vector2.ZERO
func apply_knockback(dir: Vector2, knockback_power) -> void:
	knockback_velocity = dir.normalized() * (stun_knockback_power+knockback_power) * 150


var dying : bool = false
func _die() -> void:
	if dying: return
	
	dying = true
	can_think = false
	
	for l in range(1,6):
		set_collision_mask_value(l,false)
		set_collision_layer_value(l,false)
	
	
	for d in Drops.keys():
		for i in range(Drops[d]):
			G.spawn_object(d,global_position + 100*Vector2(randf_range(-1,1),randf_range(-1,1)))
	G.main.player.on_enemy_kill()
	
	
	
	AM.disappear(self,0.2)
	await get_tree().create_timer(0.5).timeout.connect(queue_free)

func _update_animation(_delta: float) -> void:
	if current_dir.length()>0.1:
		if is_instance_valid(entity_sprite):
			if current_dir.x>0:
				entity_sprite.flip_h = flip_h_reversed
			else:
				entity_sprite.flip_h = !flip_h_reversed
			
			if enable_sqeeze_during_movement:
				_sqeeze_animation(_delta)

var OUTLINE_MATERIAL = preload("res://Assets/materials/outline_material.tres")	
func highlight(time : float = 0.2):
	entity_sprite.material = OUTLINE_MATERIAL
	
	await get_tree().create_timer(time).timeout
	entity_sprite.material = null

var normal_scale : Vector2
var _sqeeze_anim_time : float = 0
func _sqeeze_animation(delta : float):
	
	if _sqeeze_anim_time<sqeeze_time:
		_sqeeze_anim_time += delta
		return
	
	if current_dir.length()<=0: return
	#if !is_instance_valid(entity_sprite): return
	
	_sqeeze_anim_time = 0
	var t := create_tween()
	
	t.tween_property(entity_sprite,'scale',Vector2(normal_scale.x,normal_scale.y*squeeze_multiplier_y),sqeeze_time/2)
	
	await t.finished
	
	t = create_tween()
	t.tween_property(entity_sprite,'scale',normal_scale,sqeeze_time/2)
	
	await t.finished
	
	

func _random_dir() -> Vector2:
	var angle := _rng.randf_range(0.0, TAU)
	return Vector2(cos(angle), sin(angle))

func _on_detection_body_entered(body: Node) -> void:
	if body is Player:
		target = body
		#state = States.Attacking
'''
func _on_detection_body_exited(body: Node) -> void:
	if body == target:
		target = null
		if _rng.randi() % 2 == 0:
			state = States.Wandering
		else:
			state = States.Idle

		if state == States.Wandering:
			current_dir = _random_dir()
			steps = _rng.randf_range(wander_dir_time_min, wander_dir_time_max)
'''
	
