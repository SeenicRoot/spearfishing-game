class_name RedFish
extends Fish

func _on_timer_timeout() -> void:
	timer.wait_time = [1.0, 1.5].pick_random()
	if can_move:
		var weight = randf()
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))	
		## Constraining basic movement to the horizontal axis
		## x = -1 = LEFT, x = 1 = RIGHT, y = -1 = UP, y = 1 = DOWN
		if previous_direction.x < 0  and weight < 0.85: ## more likely to not change direction
			direction = Vector2(randf_range(-1, 0), randf_range(-1, 1))	
		elif previous_direction.x > 0 and weight < 0.85: ## more likely to not change direction
			direction = Vector2(randf_range(0, 1), randf_range(-1, 1))	
		previous_direction = direction
