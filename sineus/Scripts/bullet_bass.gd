extends Bullet

func _ready() -> void:
	#$Sprite2D.flip_v = direction[0] < 0
	
	area_2d.body_entered.connect(body_entered)
	await get_tree().create_timer(3).timeout
	queue_free()

func _process(delta: float) -> void:
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
	if !b.has_method('take_damage'):
		return
	
	if sender == b: return
	
	
	if b is Enemy:
		b.take_damage(damage, direction, knockback_power)
	else:
		b.take_damage(damage)
	
		
	
