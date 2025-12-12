extends Node2D

@export var debug: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	updateCharText()
	if !G.watchedIntro:
		G.watchedIntro = true
		$CanvasLayer/Intro.visible = true
		await get_tree().create_timer(1.0).timeout
		AM.appear($CanvasLayer/Intro/Sineus) 
		Sounds.play_sound("button",-5)
		await get_tree().create_timer(1.0).timeout
		AM.disappear($CanvasLayer/Intro/Sineus) 
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/Intro/ColorRect.set_mouse_filter(2)
		AM.disappear($CanvasLayer/Intro/ColorRect) 
		$AnimationPlayer.play("song")
	else:
		$AnimationPlayer.play("song")
		
var time_passed = 0.0
func _process(_delta: float) -> void:
	$BackgroundParallax.position = get_global_mouse_position()/-15/Vector2(1,1.5)
	$Background2.position = get_global_mouse_position()/-25/Vector2(1,1.5)
	$Background.position = get_global_mouse_position()/-30/Vector2(1,1.5)
	time_passed = time_passed + _delta

func _on_button_play_pressed() -> void:
	$CanvasLayer/Buttons.visible = false
	$CanvasLayer/CharSelect.visible = true
	curr_char_idx = 0
	updateCharText()
	

func _on_button_options_pressed() -> void:
	$CanvasLayer/Buttons.visible = false
	$CanvasLayer/Options.visible = true
	
var curr_char_idx: int = 0
var characters = ["basic","kick","kick_snare"]

func updateCharText():
	$CanvasLayer/CharSelect/CharName.text = characters[curr_char_idx]

func _on_button_prev_char_pressed() -> void:
	if curr_char_idx>0:
		curr_char_idx-=1
	updateCharText()

func _on_button_next_char_pressed() -> void:
	if curr_char_idx<2:
		curr_char_idx+=1
	updateCharText()

func _on_button_select_char_pressed() -> void:
	if !debug :
		AM.disappear(self) 
		await get_tree().create_timer(1.0).timeout
	G.character = characters[curr_char_idx]
	get_tree().change_scene_to_file("res://Scenes/UI/intro.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_close_pressed() -> void:
	$CanvasLayer/CharSelect.visible = false
	$CanvasLayer/Buttons.visible = true
