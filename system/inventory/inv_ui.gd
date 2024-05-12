extends Control

var is_open = false

func _ready():
	close()
	
func open(): 
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	
func _process(delta):
	if Input.is_action_just_pressed("i"):
		print("i")
		if is_open:
			close()
		else:
			open()
