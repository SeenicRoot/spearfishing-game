extends Fish 

func move(delta: float) -> void:
	if is_being_attacked:
		speed = 2000
		change_sprite_direction()
		velocity += direction * speed * delta
	else:
		speed = 1000
		change_sprite_direction()
		velocity += direction * speed * delta
	move_and_slide()
	velocity = direction * 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(delta)

func _on_timer_timeout() -> void:
	timer.wait_time = 2.0
	is_being_attacked = [false, true].pick_random()
	if can_move:
		direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()
