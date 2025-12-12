extends RangedEnemy


@onready var col: CollisionShape2D = $CollisionShape2D

const SCHOCKWAVE = preload("uid://dmgws6u41dquc")
const AREA_INDICATOR = preload("res://Scenes/effects/area_indicator.tscn")

func _ready() -> void:
	super()
	await get_tree().create_timer(0.1).timeout
	
	var ind = G.spawn_object(AREA_INDICATOR,global_position)
	ind.time = 1
	ind.z_index = z_index-1
	
	can_think = false
	
	col.disabled = true
	var normal_pos : Vector2 = entity_sprite.position
	entity_sprite.rotation_degrees = _rng.randf_range(-360,360)
	entity_sprite.position.y -= 400
	
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(entity_sprite,'rotation_degrees',0,1)
	t.tween_property(entity_sprite,'position',normal_pos,1)
	
	await t.finished
	
	var sc : Bullet = G.spawn_bullet(self,SCHOCKWAVE,global_position,Vector2.ZERO,10)
	sc.z_index = z_index-1
	sc.scale *= 1.5
	# ПОФИКСИТЬ НЕ РАБОТАЕТ ИЗ ЗА НОТИФАЕРА
	get_tree().create_timer(0.5).timeout.connect(
		
		func():
			can_think = true
			col.disabled = false
	)
	
	

var anim_time : float = 0
var f : int = 0
func _process(delta: float) -> void:
	super(delta)
	if state == States.Chasing or state == States.Attacking:
		anim_time += delta * 9
		f = wrap(int(anim_time),0,7)
		
		entity_sprite.frame = f
