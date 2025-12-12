extends ColorRect

func show_tutor():
	var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	return_tween.tween_property(self, "position", Vector2(56.0,293.0), 0.2)
	
func close_tutor():
	G.main.player.currTutorTask+=1
	if !G.main.firstTutorialTask:
		G.main.firstTutorialTaskCompleted()
	var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	return_tween.tween_property(self, "position", Vector2(-577.0,293.0), 0.3)
