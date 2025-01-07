extends Node2D

@onready var timer = $Timer
@onready var game_over_menu = $CanvasLayer2/GameOver
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var timer_label = $CanvasLayer2/Panel/TimerLabel
@onready var background_music = $BackgroundMusic 

var game_active: bool = true  # game aktif

func _ready():
	GameManager.update_score_ui()
	setup_timer()
	start_background_music()

func setup_timer():
	timer.wait_time = 60  # timer game
	timer.timeout.connect(on_timer_timeout)
	timer.start()

func on_timer_timeout():
	game_active = false  # set game menjadi tidak aktif
	GameManager.finalize_highscore()  # finalize highscore
	disable_character_movement()  # nonaktifkan movement character
	disable_interactions()  # nonaktifkan interaksi
	show_game_over_menu()
	stop_background_music()  

func disable_interactions():
	# nonaktifkan interaksi di semua objek (Truck, House, dll)
	var house_nodes = get_tree().get_nodes_in_group("houses")
	for house in house_nodes:
		house.set_process(false)  # matikan proses
	var truck = get_node_or_null("Truck")
	if truck:
		truck.set_process(false)  # matikan proses interaksi di truk

	game_active = false  # jika timeout game aktif menjadi false
	GameManager.finalize_highscore()  # finalize highscore dengan score temp
	disable_character_movement()  # disable character movement 
	show_game_over_menu()
	stop_background_music()  

func _process(delta):
	if game_active and not timer.is_stopped():  # timer berjalan
		update_timer_label()
	if Input.is_action_just_pressed("escape") and game_active:
		if not pause_menu.is_visible():
			pause_menu.pause()  # panggil fungsi pause dari PauseMenu
		else:
			pause_menu.resume()  # panggil fungsi resume dari PauseMenu

func update_timer_label():
	if timer_label and timer:
		var time_left = int(timer.time_left) 
		timer_label.text = "Time: %d" % time_left

func show_game_over_menu():
	if game_over_menu:
		game_over_menu.show()
		game_active = false  # memastikan game tidak aktif

func disable_character_movement():
	var character = get_node_or_null("CharacterBody2D")
	if character:
		character.set_physics_process(false)  # matikan physics process

func start_background_music():
	if background_music:
		background_music.play() 

func stop_background_music():
	if background_music:
		background_music.stop() 
