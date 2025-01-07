extends Node2D

# Variabel
var desired_package: String = "" # paket yang diinginkan rumah ini
var received_package: bool = false # status  paket setelah diterima

# Referensi
@onready var interaction_label = $Area2D/Label
@onready var deliver_sound = $DeliverSound
@onready var wrong_sound = $WrongSound

var detected_character = null

func _ready():
	interaction_label.visible = false

func assign_package(package_path: String):
	desired_package = package_path
	var package_name = desired_package.split("/")[desired_package.split("/").size() - 1].replace(".png", "")
	interaction_label.text = "Needs: " + package_name

func _on_area_2d_body_entered(body):
	if body.name == "MainCharacter":
		detected_character = body
		interaction_label.text = "[F] TO DELIVER"
		interaction_label.visible = true

func _on_area_2d_body_exited(body):
	if body == detected_character:
		detected_character = null
		interaction_label.visible = false

func _process(delta):
	if not get_tree().current_scene.game_active:
		return  # abaikan jika game tidak aktif
	if detected_character and Input.is_action_just_pressed("deliver"):
		if detected_character:
			var carried_package = detected_character.carrying_package
			var target_house = detected_character.target_house
			if carried_package == "":
				# jika tidak membawa paket
				interaction_label.text = "You have no package!"
				if wrong_sound:
					wrong_sound.play()
			elif target_house != name:
				# rumah tujuan tidak sesuai
				interaction_label.text = "Wrong House!!"
				detected_character.deliver_package()
				GameManager.add_score(-5)  # kurangi score
				if wrong_sound:
					wrong_sound.play()
			elif carried_package == desired_package:
				detected_character.deliver_package()  # hapus paket setelah pengiriman
				received_package = true
				interaction_label.text = "Delivered!"
				GameManager.add_score(10)  # tambah score
				if deliver_sound:
					deliver_sound.play()



