extends Node2D
class_name SpawnableProp

@export var sprite : Sprite2D
@export var flip_h : bool

func _ready() -> void:
	sprite.flip_h = flip_h
