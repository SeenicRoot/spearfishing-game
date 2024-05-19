class_name SwordFish
extends Fish

func move(_delta: float) -> void:
	if is_being_attacked:
		change_sprite_direction()
		apply_central_force(direction * acceleration * 2)
	else:
		change_sprite_direction()
		apply_central_force(direction * acceleration)

func _on_timer_timeout() -> void:
	acceleration = 300
	point_value = 100
	timer.wait_time = 2.0
	if can_move:
		var weight = randf()
		direction = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2(-1, -1), Vector2(-1, 1), Vector2(1, 1), Vector2(1, -1)].pick_random()
		## Constraining basic movement to the horizontal axis
		## x = -1 = LEFT, x = 1 = RIGHT, y = -1 = UP, y = 1 = DOWN
		if previous_direction == direction and direction.y == -1 and weight < 0.95:
			direction = [Vector2.DOWN, Vector2(-1, 1), Vector2(1, 1)].pick_random()
		elif previous_direction == direction and direction.y == 1 and weight < 0.95:
			direction = [Vector2.UP, Vector2(-1, -1), Vector2(1, -1)].pick_random()
		previous_direction = direction
		print(direction)

func change_sprite_direction() -> void:
	if direction == Vector2(-1, -1):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d. = 225.0
	elif direction == Vector2.UP:
		animated_sprite_2d.global_rotation = 270.0
	elif direction == Vector2(1, -1):
		animated_sprite_2d.global_rotation = 315.0
	elif direction == Vector2.LEFT:
		animated_sprite_2d.flip_h = true
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.flip_h = false
	elif direction == Vector2(-1, 1):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.global_rotation = 135.0
	elif direction == Vector2.DOWN:
		animated_sprite_2d.global_rotation = 90.0
	elif direction == Vector2(1, 1):
		animated_sprite_2d.global_rotation = 45.0
