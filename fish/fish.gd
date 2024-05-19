class_name Fish
extends RigidBody2D

@export var acceleration: float = 60.0
@export var point_value: int = 10

var direction: Vector2
var previous_direction: Vector2

var can_move: bool = true
var is_being_attacked: bool = false

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var timer := $Timer as Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_move:
		move(delta)


func move(_delta: float) -> void:
	if is_being_attacked:
		change_sprite_direction()
		apply_central_force(direction * acceleration * 2)
	else:
		change_sprite_direction()
		apply_central_force(direction * acceleration)
	

func _on_timer_timeout() -> void:
	timer.wait_time = [1.0, 1.5, 2.0].pick_random()
	if can_move:
		var weight = randf()
		direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
		## Constraining basic movement to the horizontal axis
		## x = -1 = LEFT, x = 1 = RIGHT, y = -1 = UP, y = 1 = DOWN
		if previous_direction == direction and direction.y == 1 and weight < 0.8:
			direction = Vector2.UP
		elif previous_direction == direction and direction.y == 1 and weight < 0.8:
			direction = Vector2.DOWN
		else:
			if direction.x == -1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			elif direction.x == 1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			elif direction.y == -1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN].pick_random()
			elif direction.y == 1:
				direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP].pick_random()
		previous_direction = direction
	
func change_sprite_direction() -> void:
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
		collision_shape_2d.position.x = -(abs(collision_shape_2d.position.x))
	else:
		animated_sprite_2d.flip_h = false
		collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
