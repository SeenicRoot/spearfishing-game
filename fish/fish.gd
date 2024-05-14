extends CharacterBody2D

@export var speed: float = 60

var direction: Vector2

var is_fish_moving: bool = false
var is_fish_being_attacked: bool = false
var is_fish_hooked: bool = false
var repeated_movement: bool = false

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D
@onready var timer := $Timer as Timer

func move(delta: float) -> void:
	if is_fish_hooked:
		## Unable to act, dragged towards the player
		## if harpoon collides fish hitbox, capture
		is_fish_hooked = false
	elif is_fish_being_attacked:
		speed = 120
		sprite_direction(direction)
		velocity += direction * speed * delta
		velocity = velocity.limit_length(100.0)
	elif !is_fish_moving:
		speed = 60
		sprite_direction(direction)
		velocity += direction * speed * delta
		velocity = velocity.limit_length(50.0)
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(delta)

func _on_timer_timeout() -> void:
	timer.wait_time = [1.0, 1.5, 2.0].pick_random()
	is_fish_being_attacked = [false, true].pick_random()
	if !is_fish_moving:
		## Constraining basic movement to the horizontal axis
		if direction.x == -1:
			direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			repeated_movement = false;
		elif direction.x == 1:
			direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
			repeated_movement = false;
		elif direction.y == -1 and repeated_movement == false:
			direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP].pick_random()
			repeated_movement = true;
		elif direction.y == 1 and repeated_movement == false:
			direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN].pick_random()
			repeated_movement = true;
		else: ## Initial movement
			direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()
	
func sprite_direction(direction: Vector2) -> void:
	if direction.x == -1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
func hooked() -> void:
	## if harpoon hits fish
	is_fish_hooked = true;
	
