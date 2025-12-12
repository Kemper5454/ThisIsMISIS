extends Label

var tween: Tween

var showTime: float = 0.6

func animate(msg):
	if msg == int(msg): msg = int(msg)
	if msg < 0:
		msg = "+" + str(abs(msg))
	elif msg > 0:
		msg = "-" + str(abs(msg))
	else:
		msg = "Miss"
	$".".text = msg
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	tween.tween_property(self, "global_position:y", global_position.y-30, showTime/2)
	tween.tween_property(self, "global_position:x", global_position.x+60, showTime/2)
	tween.set_parallel(false)
	tween.tween_property(self, "global_position:y", global_position.y+300, showTime*2)
	tween.set_parallel(true)
	tween.tween_property(self, "global_position:x", global_position.x+200, showTime*2)
	tween.tween_property(self, "scale", Vector2(1.0,1.0)/5, 1.0)
	await get_tree().create_timer(showTime).timeout
	queue_free()
