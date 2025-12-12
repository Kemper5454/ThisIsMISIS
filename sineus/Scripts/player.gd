extends Entity
class_name Player

var speed = 250
var experience : float = 0

var level_cost: float = 3.0

var max_health: int = 50
var is_alive: bool = true
var can_take_damage: bool = true

var damage_dealt = 0
var damage_received = 0
var enemies_killed: int = 0

var distance_to_altar = 0

var dash_cooldown : float = 2
var dash_time : float = 0.5
var bullet_scene = preload("res://Scenes/projectiles/bullet.tscn")

@onready var player_col: CollisionShape2D = $CollisionShape2D
@onready var dash_bar: TextureProgressBar = $CanvasGroup/DashBar
@onready var grid = $Grid
@onready var upgrade = $UpgradeMenu
@onready var expBar = $CanvasLayer/ExpBar
@onready var press_space: TextureRect = $CanvasGroup/DashBar/PressSpace
@onready var cam = $Camera2D

var _dash_cooldown : float = 0

var _dash_time : float = 0

var enemies_in_area: Array = []
var target: Enemy = null

var currTutorTask: int = 0

var level_up_queue: int = 0

func _ready() -> void:
	#$CanvasLayer/ExpBar.value = 0
	#z_as_relative = false
	for l in range(1,6):
		set_collision_mask_value(l,false)
		set_collision_layer_value(l,false)
	
	set_collision_layer_value(1,true)
	#set_collision_mask_value(2,true)
	set_collision_mask_value(3,true)
	set_collision_mask_value(5,true)
	
	await get_tree().create_timer(0.6).timeout
	if !G.completedTutorial:
		$CanvasLayer/Tutor.show_tutor()


func _process(delta: float) -> void:
	
	dash_bar.value = 100- (_dash_cooldown/dash_cooldown)*100
	if dash_bar.value>=100:
		press_space.show()
	else:
		press_space.hide()
		
	
	if level_up_queue>0:
		level_up()
	
func _physics_process(delta):
	if is_alive:
		
		
		
		#z_index = int(global_position.y)
		var direction = Input.get_vector("run_left", "run_right", "run_up", "run_down").normalized()
		
		if direction != Vector2.ZERO:
			
			if $StepCD.time_left <= 0:
				$StepCD.start()
				Sounds.play_sound("шаг" + str(randi_range(1,4)), -18,"SFX", 0.3, 1)
				
			$Sprite2D.flip_h = direction.x > 0
			$AnimationPlayer.play("run")
			$AnimationPlayer.speed_scale = 1.8
		else:
			$AnimationPlayer.play("idle")
			$AnimationPlayer.speed_scale = 1.0
			
		#print(player_col.disabled)
		if _dash_cooldown>0:
			_dash_cooldown -= delta
			
		if Input.is_action_just_pressed('space') and _dash_cooldown<=0:
			_dash_cooldown = dash_cooldown
			_dash_time = dash_time
			velocity = direction * speed * 3
			#player_col.disabled = true
			
			
		if _dash_time<=0:
			velocity = direction * speed
			#player_col.disabled = false
		else:
			_dash_time-=delta
			#global_position = global_position.clamp(Vector2(-1893.0,-1853.0),Vector2(1936.0,2105.0))
			
		if Input.is_action_just_pressed("esc"):
			if upgrade.is_hidden:
				$CanvasLayer/Pause.show_pause()
			
		#if Input.is_action_just_pressed("shift"):
			#$UpgradeMenu.restock()
		#
		if int(G.main.time_passed) % 1 == 0:
			$CanvasGroup/Clocks/Time.text = G.seconds_to_hhmmss(int(G.main.time_passed))
		
		move_and_slide()



func get_target_dir():
	var nearest_distance = 99999
	for enemy in enemies_in_area:
		if global_position.distance_to(enemy.global_position) < nearest_distance:
			nearest_distance = global_position.distance_to(enemy.global_position)
			target = enemy
	#AM.flash(target,-5) 
	if target:
		return global_position.direction_to(target.global_position)
	else:
		return global_position.direction_to(get_global_mouse_position())
		
func take_damage(damage : float):
	if _dash_time>0: return
	if !can_take_damage: return
	
	health -= damage
	damage_received += damage
	
	AM.shakeCam(cam,damage,0.1,2) 
	
	if health <= 0:
		die()
	
	AM.flash($Sprite2D,2)
	Sounds.play_sound("damage",-8,"SFX",0.3,1.0)
	Sounds.play_sound("scream", -2.0, "Music", 0.2, 1) 
	update_health_bar()

func heal(amount : float):
	if health + amount <= max_health:
		health += amount
		update_health_bar()
		return true
	else:
		return false

func update_health_bar():
	$CanvasGroup/HealthBar.max_value = max_health
	$CanvasGroup/HealthBar.value = health
	$CanvasGroup/HealthBarBig.max_value = max_health
	$CanvasGroup/HealthBarBig.value = health
	$CanvasGroup/HealthBarBig/Label.text = "%s/%s" % [int(health),int(max_health)]
	
func die():
	Sounds.play_sound("music_stop", 0.0, "SFX", 0.0, 1) 
	is_alive = false
	AudioServer.set_bus_volume_db(2,-80)
	$CanvasLayer/Death.animate()
	get_tree().paused = true
	
func on_enemy_kill():
	if !G.completedTutorial and currTutorTask == 1:
		$CanvasLayer/Tutor.show_tutor()
		$CanvasLayer/Tutor/Label.text = "
		Отлично! 
		Из врагов выпадает энергия — это опыт.

		Опыт наполняет твою шкалу уровня.
		Когда она заполнится — ты получишь улучшение
		"
	enemies_killed += 1

func on_drop_pickup(drop: String):
	match drop:
		"experience":
			Sounds.play_sound("exp",-2,"SFX",0.2,1)
			$CanvasLayer/ExpBar.max_value = level_cost
			$CanvasLayer/ExpBar.value = experience
			if experience >= level_cost:
				level_up_queue+=1
				experience -= level_cost
				

func level_up():
	if !G.completedTutorial and currTutorTask == 2:
		$CanvasLayer/Tutor.show_tutor()
		$CanvasLayer/Tutor/Label.text = "
			Поздравляем! Уровень повышен 
			 Выбери новую ноту, чтобы расширить свой ритм.
			Каждая нота звучит по-своему.
			 Подумай, как она впишется в твой бит.
		"
	Sounds.play_sound("lvl_up", 0.0, "SFX", 0.0, 1) 
	level_cost = int(level_cost*2)
	$UpgradeMenu.show_menu()

func show_transition(time: float = 1):
	AM.appear($CanvasLayer/Transition,time)

func _on_auto_aim_body_entered(body: Node2D) -> void:
	enemies_in_area.append(body)

func _on_auto_aim_body_exited(body: Node2D) -> void:
	enemies_in_area.erase(body)
