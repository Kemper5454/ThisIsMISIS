extends Node2D

var firstTutorialTask: bool = false

@export var spawn_enemies : bool = true
@export_range(1,3,1) var current_wave : int = 1
@export var time_passed : float = 0

@export var altars : Array[Node2D]
@onready var enemies_node = $Enemies
@onready var waves : Array = $Waves.get_children()

func animate_altars():
	for altar in altars:
		altar.animate()


@onready var player: Player = $Player
func get_random_point_around_player(r: float):
		var player_pos : Vector2 = player.global_position
		var angle = randf() * 2.0 * PI
		var final_pos : Vector2 = player_pos + Vector2(cos(angle), sin(angle)) * r
		if final_pos.x > 1800:
			final_pos.x = 1700
		if final_pos.x < -1800:
			final_pos.x = -1700
		if final_pos.y > 1800:
			final_pos.y = 1700
		if final_pos.y < -1800:
			final_pos.y = -1700
		return final_pos



var spawn_timer : = Timer.new()
var _rng : = RandomNumberGenerator.new()
func _ready() -> void:
	G.main = self
	AM.appear(self,2)
	_rng.randomize()
	
	
	#check_actions_by_second()
	
func firstTutorialTaskCompleted():
	firstTutorialTask = true
	add_child(spawn_timer)
	if spawn_enemies:
		spawn_timer.one_shot = true
		spawn_timer.timeout.connect(spawn_mobs)
		spawn_timer.start(1)
	
func _process(delta: float) -> void:
	if firstTutorialTask:
		time_passed += delta
		
	#$TextureRect.material.set_shader_parameter("noise_offset", Vector2.ONE*(time_passed/200 + sin(time_passed)/400))


func spawn_mobs():
	if time_passed < 15:
		current_wave = 1
	elif time_passed < 40:
		current_wave = 2
	elif time_passed < 80:
		current_wave = 3
	elif time_passed < 140:
		current_wave = 4
	elif time_passed < 180:
		current_wave = 5
	elif time_passed < 200:
		current_wave = 6
	elif time_passed < 235:
		current_wave = 7
	else:
		player.can_take_damage = false
		player.show_transition(5)

		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://Scenes/UI/outro.tscn")
		
		
	
	var wave : WaveNode = waves[current_wave-1]

	#wave.clear_up_dead()
	wave.add_enemies()
	spawn_timer.start(wave.randomize_timer())
		

'''
func check_actions_by_second():
	while true:
		await get_tree().create_timer(5).timeout
		if !get_tree().is_paused():
			var second = int(time_passed)
			
			if !spawn_enemies: return
			
			if second%3==0:
				for i in 2:
					var enemy = enemies.pick_random().instantiate()
					enemy.health = 3 + second%2
					add_child(enemy)
					enemy.global_position = get_random_point_around_player($Player.global_position, 600)
				
			if second > 60 and second%2==0:
				for i in 3:
					var enemy = enemies.pick_random().instantiate()
					enemy.health = 6 + second%4
					add_child(enemy)
					enemy.global_position = get_random_point_around_player($Player.global_position, 600)
			
			if second > 180 and second%4==0:
				for i in 3:
					var enemy = enemies.pick_random().instantiate()
					enemy.health = 10 + second%6
					add_child(enemy)
					enemy.global_position = get_random_point_around_player($Player.global_position, 600)
'''

			
