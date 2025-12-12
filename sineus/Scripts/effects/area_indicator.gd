extends Node2D

@onready var mesh: MeshInstance2D = $MeshInstance2D
var time : float = 5

func _ready() -> void:
	$AnimationPlayer.speed_scale = 3
	
	var t : = Timer.new()
	add_child(t)
	t.timeout.connect(queue_free)
	t.one_shot = true
	t.wait_time = time
	t.start()
	
	
