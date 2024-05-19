extends Fish 


func _on_timer_timeout() -> void:
	timer.wait_time = 2.0
	if can_move:
		direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()
		
func change_sprite_direction() -> void:
	animated_sprite_2d.flip_h = true
