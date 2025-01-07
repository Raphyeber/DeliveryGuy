extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton
@onready var highscore_label = $Panel/HighScore
@onready var delivery_game_scene = "res://scenes/delivery_game.tscn"

func _ready():
	update_highscore_label()

func _on_start_button_pressed():
	GameManager.reset_score()
	get_tree().change_scene_to_file(delivery_game_scene)

func _on_exit_button_pressed():
	get_tree().quit()

func update_highscore_label():
	highscore_label.text = "Highscore: " + str(GameManager.highscore)
