class_name SwordFish
extends Fish

func _on_timer_timeout() -> void:
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
