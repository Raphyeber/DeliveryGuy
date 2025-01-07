extends Node2D

@export var package_sprites: Array = [
	"res://assets/sprites/box1.png",
	"res://assets/sprites/box2.png",
	"res://assets/sprites/box3.png"
]

# Referensi
@onready var interaction_label = $Area2D/Label
var validated_houses: Array = [] # menyimpan node rumah yang valid

# variabel untuk menyimpan referensi ke MainCharacter
var main_character = null

func _ready():
	randomize() # hasil random 
	interaction_label.visible = false 

	# validasi rumah setelah tree siap
	call_deferred("validate_houses")

func validate_houses():
	validated_houses.clear()
	# ambil semua node dalam group "houses"
	var house_nodes = get_tree().get_nodes_in_group("houses")
	for house_node in house_nodes:
		if house_node and house_node not in validated_houses:
			# menggunakan get_node_or_null untuk memastikan node valid
			var valid_house = get_node_or_null(house_node.get_path())
			if valid_house:
				validated_houses.append(valid_house)
				print("Added house to validated list: ", valid_house.name)
	print("Total validated houses: ", validated_houses.size())

func _on_area_2d_body_entered(body):
	if body.name == "MainCharacter":
		main_character = body
		interaction_label.text = "[E] TO PICKUP PACKAGE"
		interaction_label.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "MainCharacter":
		main_character = null
		interaction_label.visible = false

func _process(delta):
	if not get_tree().current_scene.game_active:
		return  # abaikan jika game tidak aktif
	if main_character and Input.is_action_just_pressed("interact"):
		if main_character.carrying_package != "":
			return  # abaikan jika sudah membawa paket
		else:
			var random_sprite = package_sprites[randi() % package_sprites.size()]
			if validated_houses.size() > 0:
				var random_house = validated_houses[randi() % validated_houses.size()]
				random_house.assign_package(random_sprite)  # assign paket ke rumah
				main_character.pick_up_package(random_sprite, random_house.name)  # tambahkan nama rumah tujuan
			else:
				print("Error: No houses available for assignment!")


