extends Node2D
class_name Bullet

signal destroy

@export var speed: int = 450
var direction: Vector2 = Vector2.ZERO 
@export var damage: float = 1
@export var knockback_power : float = 1
@export var scene_after_hit : PackedScene
var sender

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	for l in range(1,6):
		area_2d.set_collision_mask_value(l,false)
		area_2d.set_collision_layer_value(l,false)
	
	if sender is Attack:
		area_2d.set_collision_layer_value(3,true)
		area_2d.set_collision_mask_value(2,true)
		
	elif sender is Enemy:
		area_2d.set_collision_layer_value(4,true)
		area_2d.set_collision_mask_value(1,true)
	
	area_2d.set_collision_mask_value(5,true)
	
	
	scale *= 1 + (damage-1)/10.0
	#$Sprite2D.flip_v = direction[0] < 0
	destroy.connect(queue_free)
	area_2d.body_entered.connect(body_entered)
	
	await get_tree().create_timer(2).timeout
	queue_free()

func _process(delta: float) -> void:
	#rotation = direction.angle()
	global_position += direction * delta * speed

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body and body is Entity:
		#if sender and sender is Player:
			#sender.on_bullet_land(self)
		#else:
			#body.take_damage(damage)
		#if body and body is Player and !body.can_take_damage:
			#return
		#queue_free()
		

func body_entered(b):
	if b.has_method('take_damage'):
		if b is Enemy:
			b.take_damage(damage, direction, knockback_power)
		else:
			b.take_damage(damage)
	
	if scene_after_hit:
			G.spawn_object(scene_after_hit,global_position)
			
	
	
	
	destroy.emit()
		
	
