extends Node2D

var target 

func animate():
	var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO).set_parallel(false)
	return_tween.tween_property($Altar, "scale", Vector2(1.1,1.1), 0.05)
	return_tween.tween_property($Altar, "scale", Vector2(1.0,1.0), 0.1)

func _process(delta: float) -> void:
	if target:
		target.distance_to_altar = target.global_position.distance_to(global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		target.distance_to_altar = 0
		target = null
