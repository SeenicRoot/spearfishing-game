extends Camera2D

var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	global_translate(input_vec * speed * delta)
