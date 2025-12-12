extends TextureProgressBar

var exp_speed: float = 0.4
var time_passed : float = 0
func _process(delta: float) -> void:
	time_passed += delta
	material.set_shader_parameter("noise_offset", Vector2(time_passed*exp_speed,1))
	material.set_shader_parameter("tile_offset", Vector2(time_passed*exp_speed/6,1))
