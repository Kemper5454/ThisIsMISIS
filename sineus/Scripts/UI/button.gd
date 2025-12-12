extends TextureButton

@export var t_name = "aboba"
@export_multiline var t_desc = "aboba2"
@export var has_tooltip: bool = false

var init_scale: Vector2 = scale

func _ready() -> void:
	init_scale = scale

func _on_mouse_entered() -> void:
	AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale,0],[init_scale*1.1,0.1])
	Sounds.play_sound("cell",-8,"SFX")
	if has_tooltip: Tooltip.target = self

func _on_mouse_exited() -> void:
	AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale*1.1,0],[init_scale,0.1])
	if has_tooltip: Tooltip.target = null

func _on_button_down() -> void:
	AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale*1.05,0],[init_scale,0.05])

func _on_button_up() -> void:
	AM.jump(self,Tween.TransitionType.TRANS_EXPO,[init_scale,0],[init_scale*1.1,0.1])
