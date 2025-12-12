extends Area2D

@onready var rect_shape: RectangleShape2D = $CollisionShape2D.shape

@export var altar_spawns : float = 2
@export var count_min := 10
@export var count_max := 20
@export var min_dist := 100.0          # desired minimum distance between points
@export var relax_iters := 25          # number of repulsion iterations
@export var repel_strength := 0.6      # how much to move per iteration (0..1)
@export var jitter := 0.5  

func get_random_point_in_area() -> Vector2:
	var extents = rect_shape.extents
	var random_x = randf_range(-extents.x, extents.x)
	var random_y = randf_range(-extents.y, extents.y)
	return global_position + Vector2(random_x, random_y)

var _rng : = RandomNumberGenerator.new()

@export var props : Array[PackedScene]
const ALTAR = preload("res://Scenes/altar.tscn")


var points : Array[Vector2]

func _ready() -> void:
	await get_tree().process_frame
	
	_rng.randomize()
	for i in range(_rng.randi_range(10,20)):
		points.append(get_random_point_in_area())
	
	
	_relax_points_in_rect(points, min_dist, relax_iters, repel_strength, jitter)
	
	for i in range(len(points)-altar_spawns):
		var p : Vector2 = points[i]
		var obj : SpawnableProp = G.spawn_object(props.pick_random(),p)
		obj.flip_h = _rng.randi_range(0,1)
	
	for i in range(len(points)-altar_spawns,len(points)):
		var p : Vector2 = points[i]
		var obj : Node2D = G.spawn_object(ALTAR,p)
		G.main.altars.append(obj)
		
		
	
	
func _relax_points_in_rect(pts: Array[Vector2], r: float, iters: int, strength: float, jitter_amt: float) -> void:
	var ext : Vector2 = rect_shape.extents

	for _i in iters:
		# accumulate displacements
		var disp := PackedVector2Array()
		disp.resize(pts.size())

		for a in pts.size():
			var d := Vector2.ZERO
			for b in pts.size():
				if a == b: continue
				var delta := pts[a] - pts[b]
				var dist := delta.length()
				if dist > 0.001 and dist < r:
					# push away proportional to overlap
					var push := (r - dist) / r
					d += delta.normalized() * push
			# a touch of randomness helps avoid clumping
			if jitter_amt > 0.0:
				d += Vector2(
					randf_range(-jitter_amt, jitter_amt),
					randf_range(-jitter_amt, jitter_amt)
				)
			disp[a] = d

		# apply displacements and clamp to the rectangle
		for i in pts.size():
			pts[i] += disp[i] * strength
			pts[i].x = clamp(pts[i].x, -ext.x, ext.x)
			pts[i].y = clamp(pts[i].y, -ext.y, ext.y)
	
