extends Control

var is_open = false

func _ready():
	close()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if is_open:
			close()
		else:
			open()
		
func open(): 
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false
