extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# gravity (sudah dari sana)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# variabel tambahan untuk paket
var carrying_package: String = ""  # path sprite paket yang sedang dibawa
var target_house: String = ""  # nama rumah tujuan
@onready var package_sprite = $Marker2D/Sprite2D
@onready var target_label = $Marker2D/Label
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var pick_up = $PickUp
@onready var dust = $Dust  

func _ready():
	package_sprite.visible = false
	target_label.visible = false  # label tidak terlihat di awal
	dust.emitting = false  # matikan particle di awal

func pick_up_package(sprite_path: String, house_name: String):
	if carrying_package != "" or not get_tree().current_scene.game_active:
		return  # Abaikan jika sudah membawa paket atau game tidak aktif
	carrying_package = sprite_path
	target_house = house_name
	package_sprite.texture = load(sprite_path)
	package_sprite.visible = true
	target_label.text = "To: " + house_name
	target_label.visible = true
	if pick_up:
		pick_up.play()

func deliver_package():
	if carrying_package == "" or not get_tree().current_scene.game_active:
		return  # Abaikan jika tidak membawa paket atau game tidak aktif
	carrying_package = ""
	target_house = ""
	package_sprite.visible = false
	target_label.visible = false

func _physics_process(delta):
	# Add gravity
	if not get_tree().current_scene.game_active:
		velocity = Vector2.ZERO
		return
	if not is_on_floor():
		velocity.y += gravity * delta

	# Animations
	if not is_on_floor():
		if velocity.y > 0:
			animated_sprite_2d.animation = "Fall"
		else:
			animated_sprite_2d.animation = "Jump"
	elif abs(velocity.x) > 1:
		animated_sprite_2d.animation = "Run"
	else:
		animated_sprite_2d.animation = "Idle"

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction: -1, 0, 1
	var direction = Input.get_axis("left", "right")
	# Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Movement
	velocity.x = direction * SPEED

	# Move and slide
	move_and_slide()

	# Handle particle emission
	handle_dust_emission()

func handle_dust_emission():
	# aktifkan particle jika karakter bergerak atau lompat
	if not is_on_floor() or abs(velocity.x) > 1:
		dust.emitting = true
	else:
		dust.emitting = false
