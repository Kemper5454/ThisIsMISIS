extends Control

var attacks: Array = []

var is_hidden: bool = true

@onready var attacks_node = $Attacks
@onready var buttons_node = $ButtonSelect

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shift"):
		#restock()
		

func restock():
	for attack in attacks_node.get_children():
		attack.queue_free()
	attacks = []
	
	await get_tree().create_timer(0.05).timeout
	G.attack_pool.shuffle()
	for i in 3:
		var new_attack = load(G.attack_pool[i]).instantiate()
		attacks_node.add_child(new_attack)
		new_attack.global_position =  attacks_node.global_position + Vector2(-400 + 400*i,0)
		
	for attack in attacks_node.get_children():
		attacks.append(attack)
		attack.selected.connect(return_prev_selected)

func return_prev_selected(attack):
	if attacks.has(attack):
		var i: int = 0
		for a in attacks:
			if a != attack:
				a.reparent(attacks_node,true)
				var return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
				return_tween.tween_property(a, "global_position", attacks_node.global_position + Vector2(-400 + 400*i,0), 0.1)
			i += 1

func show_menu():
	get_tree().paused = true
	if is_hidden:
		G.main.player.level_up_queue-=1
		G.main.player.expBar.exp_speed = 2
		G.main.player.grid.set_every_slot(true)
		is_hidden = false
		restock()
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
		tween.tween_property(self, "position", Vector2(-953.0,-521.0), 1.0)

func _on_button_select_pressed() -> void:
	get_tree().paused = false
	G.main.player.grid.set_every_slot(false)
	
	G.main.player.expBar.exp_speed = 0.4
	is_hidden = true
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_EXPO)
	tween.tween_property(self, "position", Vector2(-953.0,2000), 1.0)
		
func _on_attacks_child_order_changed() -> void:
	
	if is_instance_valid(attacks_node):
		if G.main.player.is_alive:
			if attacks_node and attacks_node.get_child_count() == 3:
				for attack in attacks_node.get_children():
					if attacks.has(attack):
						buttons_node.disabled = false
						buttons_node.visible = true
						return
				buttons_node.disabled = true
				buttons_node.visible = false
			elif attacks_node and attacks_node.get_child_count() < 3:
				if buttons_node:
					buttons_node.disabled = false
					buttons_node.visible = true
			else:
				if buttons_node:
					buttons_node.disabled = true
					buttons_node.visible = false
