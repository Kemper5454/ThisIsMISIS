extends Bullet

func _ready() -> void:
	#$Sprite2D.flip_v = direction[0] < 0
	destroy.connect(queue_free)
	area_2d.body_entered.connect(body_entered)
	AM.disappear(self,1)
	await get_tree().create_timer(0.1).timeout
	$Area2D.monitoring = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	#rotation = direction.angle()
	$Sprite2D.scale += Vector2(0.2,0.2) * delta * 40

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
		b.take_damage(damage,(b.global_position - global_position).normalized(), knockback_power)
	else:
		b.take_damage(damage)
	
	#destroy.emit()
		
	
