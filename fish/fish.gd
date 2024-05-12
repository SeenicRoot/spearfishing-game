extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var direction: Vector2
var speed = 60

var is_fish_moving: bool
var is_fish_being_attacked: bool
@onready var timer = $Timer

func _ready():
	direction = Vector2.LEFT
	is_fish_moving = false
	is_fish_being_attacked = false
	
func move(delta):
	if is_fish_being_attacked:
		speed = 120
		velocity += direction * speed * delta
		velocity = velocity.limit_length(100.0)
	elif !is_fish_moving:
		speed = 60
		velocity += direction * speed * delta
		velocity = velocity.limit_length(50.0)
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)

func _on_timer_timeout():
	timer.wait_time = random([1.0, 1.5, 2.0])
	is_fish_being_attacked = random([false, true])
	if !is_fish_moving:
		if direction.x == -1:
			direction = random([Vector2.LEFT, Vector2.UP, Vector2.DOWN])
			animated_sprite_2d.flip_h = true
			print(direction)
			print(is_fish_being_attacked)
			
		elif direction.x == 1:
			direction = random([Vector2.RIGHT, Vector2.UP, Vector2.DOWN])
			animated_sprite_2d.flip_h = false
			print(direction)
			print(is_fish_being_attacked)
			
		elif direction.x == 0:
			direction = random([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])
			print(direction)
			print(is_fish_being_attacked)

func random(array):
	array.shuffle()
	return array.front()
