extends Fish 

func move(delta: float) -> void:
	if is_hooked:
		## Unable to act, dragged towards the player
		## if harpoon collides fish hitbox, capture
		is_hooked = false
	elif is_being_attacked:
		speed = 2000
		sprite_direction(direction)
		velocity += direction * speed * delta
	elif !is_moving:
		speed = 1000
		sprite_direction(direction)
		velocity += direction * speed * delta
	move_and_slide()
	velocity = direction * 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(delta)

func _on_timer_timeout() -> void:
	timer.wait_time = 2.0
	is_being_attacked = [false, true].pick_random()
	if !is_moving:
		direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()

func sprite_direction(direction: Vector2) -> void:
	if direction.x == -1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func hooked() -> void:
	## if harpoon hits fish
	is_hooked = true;
	
