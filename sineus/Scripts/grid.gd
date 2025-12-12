extends Control

var speed
var time_passed = 0.0
var max_x
var time_space = 174/60.0/8.0
var beat: int = 0
var last_beat: int = -1

var slot_len: int = 8
var slots: Array = []



func _ready() -> void:
	await get_tree().process_frame
	for x in slot_len:
		for y in 2:
			if G.decks.get(G.character)[y][x] == "none":
				continue
			get_slot(y,x).add_attack(load("res://Scenes/attacks/attack_" + G.decks.get(G.character)[y][x] + ".tscn").instantiate())
			#slots.append(get_slot(y,x))
	
	#var start_attack = load(G.attack_pool.pick_random()).instantiate()
	#start_attack.can_move = false
	#slots.pick_random().add_attack(start_attack)
	
	for x in slot_len:
		for y in 2:
			get_slot(y,x).id = x
	
	speed = 1/time_space * (128+10)
	
	max_x = slot_len*128 + 5 + 64

	
func _process(delta: float) -> void:
	Tooltip.mouse_pos = get_local_mouse_position()
	time_passed += delta
	$Playback.position.x += speed * delta
	
	var pos = $Music.get_playback_position() # in seconds
	beat = int(pos / (60.0 / 174))
	if beat != last_beat:
		last_beat = beat
		on_beat(beat) # вызываем функцию при каждом новом бите
	
func on_beat(curr_beat: int) -> void:
	if curr_beat%2==0: 
		G.main.animate_altars()
	
	var x = curr_beat%8
	if x == 0:
		$Playback.position.x = 0
	
	if G.main.player.upgrade.is_hidden:
		if x == 0:
			for i in slot_len:
				for j in 2:
					if get_slot(j,i).get_attack():
						get_slot(j,i).get_attack().before_play(beat)
		#
		for y in 2:
			var last_slot = get_slot(y,x-1)
			AM.jump(last_slot,Tween.TransitionType.TRANS_EXPO,[Vector2.ONE*1.1,0.0],[Vector2.ONE*1.0,0.05])
		
		
		for y in 2:
			var current_slot = get_slot(y,x)
			if current_slot.get_attack():
				current_slot.get_attack().play(beat)
				
			AM.flash(current_slot,5) 
			AM.jump(current_slot,Tween.TransitionType.TRANS_EXPO,[Vector2.ONE*1.0,0.0],[Vector2.ONE*1.1,0.05])
		
		Sounds.play_sound("cell", -8, "Music", 0.0, 1)
		
func set_every_slot(value: bool):
	for x in slot_len:
		for y in 2:
			if get_slot(y,x).get_attack():
				get_slot(y,x).get_attack().can_move = value
	
func get_slot(y,x):
	if $Slots.get_child(y) != null:
		if $Slots.get_child(y).get_child(x) != null:
			return $Slots.get_child(y).get_child(x)
		
