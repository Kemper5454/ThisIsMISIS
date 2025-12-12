extends Node2D
class_name SpriteEffect

@export var sprite : Sprite2D
@export var random_rotation : bool = false

enum MODES {
	play_animation,
	random_frame
}
@export var mode : MODES

func _ready() -> void:
	if random_rotation:
		rotation_degrees = randf_range(-360,360)
		
	var total_frames = (sprite.hframes * sprite.vframes) - 1
	var t : = create_tween()
	
	if mode == MODES.random_frame:
		t.set_trans(Tween.TRANS_LINEAR)
		t.set_ease(Tween.EASE_IN)
		t.tween_property(sprite,'frame',randi_range(0,total_frames),0.5)
	elif mode == MODES.play_animation:
		t.tween_property(sprite,'frame',total_frames,0.5)
		
	t.finished.connect(queue_free)
