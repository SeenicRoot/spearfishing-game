class_name Fish
extends CharacterBody2D

const VELOCITY_LIMIT: float = 50.0

@export var speed: float = 60

var direction: Vector2
var previous_direction: Vector2

var can_move: bool = true
var is_being_attacked: bool = false


@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D
@onready var timer := $Timer as Timer

func move(delta: float) -> void:
	if is_being_attacked:
		speed = 120
		change_sprite_direction()
		velocity += direction * speed * delta
		velocity = velocity.limit_length(VELOCITY_LIMIT)
	else:
		speed = 60
		change_sprite_direction()
		velocity += direction * speed * delta
		velocity = velocity.limit_length(VELOCITY_LIMIT/2)
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_move:
		move(delta)

func _on_timer_timeout() -> void:
	timer.wait_time = [1.0, 1.5, 2.0].pick_random()
	is_being_attacked = [false, true].pick_random()
	if can_move:
		var weight = randf()
		direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
		## Constraining basic movement to the horizontal axis
		if previous_direction == direction and direction.y == 1 and weight < 0.8:
			direction = Vector2.DOWN 
		elif previous_direction == direction and direction.y == -1 and weight < 0.8:
			direction = Vector2.UP
		else:
			if direction.x == -1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			elif direction.x == 1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			elif direction.y == -1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP].pick_random()
			elif direction.y == 1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN].pick_random()
		previous_direction = direction
	
func change_sprite_direction() -> void:
	if direction.x == -1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
