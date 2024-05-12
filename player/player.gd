class_name Player
extends CharacterBody2D

@export var acceleration: float = 300.0
@export var deceleration: float = 100.0
@export var max_velocity: float = 150.0

var is_accelerating: bool = false
var mouse_position: Vector2 = Vector2.ZERO
var harpoon_ready: bool = true
var flipped: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var harpoon: Node2D = $Harpoon
@onready var harpoon_x_offset: float = harpoon.position.x


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		mouse_position = event.global_position
	if event.is_action("accelerate"):
		is_accelerating = event.is_pressed()
	if event.is_action("shoot"):
		if harpoon_ready:
			shoot(mouse_position)


func _physics_process(delta: float) -> void:
	var direction := (mouse_position - global_position).normalized()

	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

	# accelerate towards cursor
	if is_accelerating:
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_velocity)
		# face direction
		if abs(direction.angle_to(Vector2.UP)) < deg_to_rad(45):
			rotation = deg_to_rad(0)
		elif abs(direction.angle_to(Vector2.DOWN)) < deg_to_rad(45):
			rotation = deg_to_rad(180)
		elif abs(direction.angle_to(Vector2.RIGHT)) < deg_to_rad(45):
			rotation = deg_to_rad(90)
		elif abs(direction.angle_to(Vector2.LEFT)) < deg_to_rad(45):
			rotation = deg_to_rad(270)

	move_and_slide()

	# point harpoon at mouse position
	harpoon.global_rotation = direction.angle() 
	if abs(rad_to_deg(harpoon.rotation)) > 90 and not flipped:
		flip_player()
	elif abs(rad_to_deg(harpoon.rotation)) < 90 and flipped:
		flip_player()


func flip_player() -> void:
	var harpoon_sprite := harpoon.get_node("Sprite2D") as Sprite2D
	harpoon.position.x = -harpoon.position.x
	sprite.flip_h = not sprite.flip_h
	harpoon_sprite.flip_v = not harpoon_sprite.flip_v
	flipped = not flipped
		

func shoot(at_position: Vector2) -> void:
	pass
