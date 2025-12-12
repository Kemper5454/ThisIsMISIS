extends RangedEnemy



var anim_time : float = 0
var f : int = 0
func _process(delta: float) -> void:
	super(delta)
	anim_time += delta * 9
	f = wrap(int(anim_time),0,7)
	
	entity_sprite.frame = f
