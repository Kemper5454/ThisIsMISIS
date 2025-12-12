extends Enemy
class_name MiniBoss1


@export_category('Mini boss 1')
@export var jump_radius : float = 150 # когда игрок ближе этого радиуса, босс будет прыгать
@export var jump_cooldown : float = 1

@export var shot_cooldown : float = 0.2
@export var shot_damage : float = 1


var jumping : bool = false
var shooting : bool = false

var jump_timer : = Timer.new()
var shot_timer : = Timer.new()

func _ready() -> void:
	super()
	
	add_child(jump_timer)
	add_child(shot_timer)
	
	jump_timer.wait_time = jump_cooldown
	jump_timer.one_shot = true
	
	shot_timer.wait_time = shot_cooldown
	shot_timer.one_shot = true
	
	jump_timer.start(0)
	shot_timer.start(0)

func _process(delta: float) -> void:
	super(delta)


var bullet : PackedScene = preload("res://Scenes/projectiles/enemy_bullet1.tscn")
const AREA_INDICATOR = preload("res://Scenes/effects/area_indicator.tscn")

func attack():
	super()
	
	var to_target := target.global_position - global_position
	var targ_pos : Vector2 = target.global_position
	
	
	if to_target.length()<=jump_radius:
		if jump_timer.time_left>0:
			return
		
		if !jumping and !shooting:
			jumping = true
			highlight()
			
			var ind = G.spawn_object(AREA_INDICATOR,targ_pos)
			ind.time = 1
			ind.z_index = z_index-1
			
			var t := create_tween()
			var animation_t := create_tween()
			
			animation_t.tween_property(entity_sprite,'frame',11,1)
			
			t.set_trans(Tween.TRANS_EXPO)
			t.set_ease(Tween.EASE_IN)
			
			
			#normal_pos - Vector2(0,400)
			t.tween_property(self,'global_position',Vector2( global_position.x + to_target.x/2   ,global_position.y - 400),0.5)
		
			
			await t.finished
			
			t = create_tween()
			t.set_trans(Tween.TRANS_EXPO)
			t.set_ease(Tween.EASE_IN_OUT)
			
			t.tween_property(self,'global_position',targ_pos,0.5)
			
			await t.finished
			
			var wave : Bullet = G.spawn_bullet(self, preload("res://Scenes/projectiles/schockwave.tscn"),$"Shockwave spawn_pos".global_position,Vector2.ZERO, 25)
			wave.z_index = z_index - 1
			
			entity_sprite.frame = 0
			
			await get_tree().create_timer(1).timeout
			
			jump_timer.start()
			jumping = false
			
	if !shooting:

		if shot_timer.time_left<=0 and to_target.length()>=chase_dist/2:
			shooting = true
			highlight(1.5)
			if randi_range(0,1):
				for times in range(3):
					await get_tree().create_timer(0.5).timeout
					for ang in range(-30,30,10):
						to_target = target.global_position - global_position
						var dir : Vector2 = to_target.normalized().rotated(deg_to_rad(ang))
						G.spawn_bullet(self,bullet,global_position,dir,shot_damage)
				
			else:
				highlight()
				var b = G.spawn_bullet(self,bullet,global_position,to_target.normalized(),shot_damage*3)
				b.scale *= 5
				
			shooting = false
			shot_timer.start()
	
	current_dir = to_target.normalized()
				
			
'''
func attack():
	super()
	var to_target := target.global_position - global_position
	var targ_pos : Vector2 = target.global_position
	
	if to_target.length()<=jump_radius:
		if _jump_cooldown>0:
			_jump_cooldown -= _think_accum
			return
	
		if !jumping:
			jumping = true
			
			var t := create_tween()
			var animation_t := create_tween()
			
			animation_t.tween_property(entity_sprite,'frame',11,1)
			
			t.set_trans(Tween.TRANS_EXPO)
			t.set_ease(Tween.EASE_IN)
			
			
			#normal_pos - Vector2(0,400)
			t.tween_property(self,'global_position',Vector2( global_position.x + to_target.x/2   ,global_position.y - 400),0.5)
		
			
			await t.finished
			
			t = create_tween()
			t.set_trans(Tween.TRANS_EXPO)
			t.set_ease(Tween.EASE_IN_OUT)
			
			t.tween_property(self,'global_position',targ_pos,0.5)
			
			await t.finished
			
			G.spawn_bullet(self, preload("res://Scenes/projectiles/schockwave.tscn"),$"Shockwave spawn_pos".global_position,Vector2.ZERO, 25)
			
			
			entity_sprite.frame = 0
			
			await get_tree().create_timer(1).timeout
			
			_jump_cooldown = jump_cooldown
			jumping = false
	else:
		
		if _shot_cooldown>=0 and !shooting:
			_shot_cooldown -= _think_accum
		elif !shooting:
			shooting = true
			_shot_cooldown = shot_cooldown
			
			
			if randi_range(0,1):
				for times in range(3):
					await get_tree().create_timer(0.5).timeout
					for ang in range(-30,30,10):
						var dir : Vector2 = to_target.normalized().rotated(deg_to_rad(ang))
						G.spawn_bullet(self,bullet,global_position,dir,shot_damage)
			
			else:
				var b = G.spawn_bullet(self,bullet,global_position,to_target.normalized(),shot_damage*10)
				b.scale *= 5
				b.speed *= 2
			
			shooting = false
	
	if !jumping:
		current_dir = to_target.normalized()
			
		
		

func _process(delta: float) -> void:
	super(delta)
'''
