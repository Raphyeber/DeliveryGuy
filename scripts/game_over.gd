extends Control

@onready var retry_button = $Retry
@onready var quit_button = $Quit

func _ready():
	hide()

func _on_retry_pressed():
	get_tree().paused = false
	GameManager.reset_score()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
