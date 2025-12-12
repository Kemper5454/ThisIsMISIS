extends Node

var main: Node2D

var character: String
var decks: Dictionary = {
	"basic": [[
		"none",
		"none",
		"none",
		"none",
		"basic",
		"none",
		"none",
		"basic",
	],[
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
	]],
	"kick": [[
		"kick",
		"none",
		"none",
		"none",
		"kick",
		"none",
		"none",
		"none",
	],[
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
		"none",
	]],
	"kick_snare": [[
		"kick",
		"none",
		"none",
		"none",
		"kick",
		"none",
		"none",
		"none",
	],[
		"none",
		"none",
		"none",
		"none",
		"snare",
		"none",
		"none",
		"none",
	]],
}

var attack_pool: Array = [
	"res://Scenes/attacks/attack_basic.tscn",
	"res://Scenes/attacks/attack_kick.tscn",
	"res://Scenes/attacks/attack_hat.tscn",
	"res://Scenes/attacks/attack_clap.tscn",
	"res://Scenes/attacks/attack_crash.tscn",
	"res://Scenes/attacks/attack_bass.tscn",
	"res://Scenes/attacks/attack_snare.tscn",
	"res://Scenes/attacks/attack_openhat.tscn",
	"res://Scenes/attacks/attack_reverse.tscn",
	"res://Scenes/attacks/attack_vibe.tscn",
]

# ai
var think_interval : float = 0.2

#settings:
var lang: int = 1
var resolution: int = 0
var watchedIntro: bool = false 
var watchedCutscene: bool = false
var completedTutorial: bool = false

func _ready() -> void:
	TranslationServer.set_locale("en")

func spawn_bullet(sender, bullet_scn, pos, dir, dmg = 1):
	var bullet = bullet_scn.instantiate()
	bullet.global_position = pos
	bullet.direction = dir
	bullet.sender = sender
	bullet.damage = dmg
	G.main.add_child(bullet)
	
	return bullet

func spawn_object(scene : PackedScene,global_position : Vector2, object_parent: Node = G.main):
	var obj = scene.instantiate()
	object_parent.call_deferred('add_child',obj)
	obj.global_position = global_position
	
	return obj

func sortByZ(a, b): 
	return a.z_index > b.z_index

func raycast_check(obj: Object, mask: int, sort_by_z: bool = false):
	var space_state: PhysicsDirectSpaceState2D = obj.get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = obj.get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		if sort_by_z:
			result.sort_custom(sortByZ)
		return result[0].collider.get_parent()
	return null
	
func spawnDamageNumber(damage: float = 0, pos: Vector2 = Vector2.ZERO):
	var n = load("res://Scenes/UI/spawntext.tscn").instantiate()
	G.main.add_child(n)
	n.global_position = pos
	n.animate(damage)
	
func seconds_to_hhmmss(seconds):
	var h = int(seconds / 3600)
	var m = int((seconds % 3600) / 60)
	var s = int(seconds % 60)
	if h == 0:
		return "%02d:%02d" % [m, s]
	else:
		return "%02d:%02d:%02d" % [h, m, s]
	
