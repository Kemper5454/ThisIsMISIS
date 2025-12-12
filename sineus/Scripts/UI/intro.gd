extends Node2D

@onready var pb: TextureProgressBar = $CanvasLayer/Control/Control/TextureProgressBar
@onready var control: Control = $CanvasLayer/Control/Control
@onready var label: Label = $CanvasLayer/Control/Control/TextureProgressBar/Label

@onready var hint_skip: Label = $CanvasLayer/Control/HintSkip
@onready var vid: VideoStreamPlayer = $CanvasLayer/Control/VideoStreamPlayer

func _ready() -> void:
	hint_skip.hide()
	control.modulate.a = 0
	vid.finished.connect(
		
		func():
			get_tree().change_scene_to_file('res://Scenes/main.tscn')
	)
	

var val : float = 0
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and !Input.is_action_pressed('space'):
		show_hint()
	
	
	
	if Input.is_action_pressed('space'):
		val += delta
		
		control.modulate.a = move_toward(control.modulate.a,1,delta)
		
		label.modulate.r = move_toward(label.modulate.r,Color.BLACK.r,delta) 
		label.modulate.g = move_toward(label.modulate.g,Color.BLACK.r,delta) 
		label.modulate.b = move_toward(label.modulate.b,Color.BLACK.b,delta) 
		
	else:
		val -= delta
		
		control.modulate.a = move_toward(control.modulate.a,0,delta)
		
		
		label.modulate.r = move_toward(label.modulate.r,Color.WHITE.r,delta) 
		label.modulate.g = move_toward(label.modulate.g,Color.WHITE.r,delta) 
		label.modulate.b = move_toward(label.modulate.b,Color.WHITE.b,delta) 
	
	val = clamp(val,0,1)
	pb.value = val * 100
	
	if val==1:
		get_tree().change_scene_to_file('res://Scenes/main.tscn')


var hint_timer : SceneTreeTimer
func show_hint():
	if is_instance_valid(hint_timer):
		if hint_timer.time_left>0: return
	
	hint_skip.show()
	hint_timer = get_tree().create_timer(1)
	await hint_timer.timeout
	
	hint_skip.hide()
	
	
