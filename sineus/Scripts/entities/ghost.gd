extends MeleeEnemy
class_name Ghost

func _ready() -> void:
	super()
	OUTLINE_MATERIAL = OUTLINE_MATERIAL.duplicate()
	
	OUTLINE_MATERIAL.set_shader_parameter('outline_size',16*2)
	

var anim_time : float = 0
var f : int = 0
func _process(delta: float) -> void:
	super(delta)
	anim_time += delta * 9
	f = wrap(int(anim_time),0,7)
	
	$EnemyGhost.frame = f
