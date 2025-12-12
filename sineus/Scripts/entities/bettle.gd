extends MeleeEnemy

var anim_time : float = 0
var f : int = 0
func _process(delta: float) -> void:
	super(delta)
	if state == States.Chasing:
		anim_time += delta * 9
		f = wrap(int(anim_time),0,4)
		
		entity_sprite.frame = f
