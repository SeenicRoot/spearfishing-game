class_name Player
extends CharacterBody2D

const MIN_ROTATE_SPEED = 25.0
const ROTATE_COOLDOWN = 0.25

@export var acceleration: float = 300.0
@export var deceleration: float = 100.0
@export var max_velocity: float = 150.0

var is_accelerating: bool = false
var mouse_position: Vector2 = Vector2.ZERO
var harpoon_ready: bool = true
var flipped: bool = false
var can_rotate_sprite: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var harpoon_launcher: HarpoonLauncher = $HarpoonLauncher
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.current_animation = "swim"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = get_global_mouse_position()
	if event.is_action("accelerate"):
		is_accelerating = event.is_pressed()
	if event.is_action_pressed("shoot"):
		if harpoon_ready:
			shoot()


func _physics_process(delta: float) -> void:
	var direction := (mouse_position - global_position).normalized()

	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

	# accelerate towards cursor
	if is_accelerating:
		if not animation_player.is_playing():
			animation_player.play()
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_velocity)
		# face direction
		if can_rotate_sprite:
			if abs(direction.angle_to(Vector2.UP)) < deg_to_rad(45):
				rotation = deg_to_rad(0)
			elif abs(direction.angle_to(Vector2.DOWN)) < deg_to_rad(45):
				rotation = deg_to_rad(180)
			elif abs(direction.angle_to(Vector2.RIGHT)) < deg_to_rad(45):
				rotation = deg_to_rad(90)
			elif abs(direction.angle_to(Vector2.LEFT)) < deg_to_rad(45):
				rotation = deg_to_rad(270)
			can_rotate_sprite = false
			get_tree().create_timer(0.25).timeout.connect(func () -> void: can_rotate_sprite = true)
	else:
		animation_player.pause()

	move_and_slide()

	# point harpoon_launcher at mouse position
	harpoon_launcher.global_rotation = direction.angle() 
	if abs(rad_to_deg(harpoon_launcher.rotation)) > 90 and not flipped:
		flip_player()
	elif abs(rad_to_deg(harpoon_launcher.rotation)) < 90 and flipped:
		flip_player()


func flip_player() -> void:
	harpoon_launcher.position.x = -harpoon_launcher.position.x
	harpoon_launcher.scale.y = -harpoon_launcher.scale.y
	sprite.flip_h = not sprite.flip_h
	flipped = not flipped
		

func shoot() -> void:
	harpoon_launcher.shoot()
