class_name Jellyfish
extends Fish

func _on_timer_timeout() -> void:
	timer.wait_time = [1.0, 1.5, 2.0].pick_random()
	if can_move:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))	
		
func change_sprite_direction() -> void:
	animated_sprite_2d.flip_h = false
