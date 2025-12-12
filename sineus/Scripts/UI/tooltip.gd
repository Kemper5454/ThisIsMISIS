extends Control

var target

var mouse_pos: Vector2

func _process(_delta: float) -> void:
	if target != null:
		$CanvasLayer/Container.reset_size()
		$CanvasLayer.visible = true
		if target != null:
			$CanvasLayer/Container/MarginContainer3/VBoxContainer/Name.text = target.t_name
			$CanvasLayer/Container/MarginContainer2/VBoxContainer/Desc.text = target.t_desc +"\n\n "
		var x_offset: int = 30
		var y_offset: int = -30
		
		if mouse_pos.x > 1400: x_offset = -300
		if mouse_pos.y > 1000: y_offset = -300
		$CanvasLayer/Container.global_position = Vector2(get_global_mouse_position().x + x_offset ,get_global_mouse_position().y + y_offset)
	else:
		$CanvasLayer.visible = false
