extends Fish 

func _ready():
	speed = 2000
	point_value = 5
	velocity_limit = 200

func move(delta: float) -> void:
	super(delta)
	velocity = direction * 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move(delta)

func _on_timer_timeout() -> void:
	timer.wait_time = 2.0
	is_being_attacked = [false, true].pick_random()
	if can_move:
		direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()
