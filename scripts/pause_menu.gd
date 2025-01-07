extends Control

func _ready():
	$AnimationPlayer.play("RESET")  # animasi mulai dari reset

func resume():
	get_tree().paused = false  # lanjutkan game
	$AnimationPlayer.play_backwards("blur")  

func pause():
	get_tree().paused = true  # pause game
	$AnimationPlayer.play("blur")  

func testEsc():
	if Input.is_action_just_pressed("escape"): 
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	GameManager.reset_score()
	get_tree().reload_current_scene() 

func _on_quit_pressed():
	resume()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")  

func _process(delta):
	testEsc()
