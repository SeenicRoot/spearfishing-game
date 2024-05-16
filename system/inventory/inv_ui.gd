extends Control

@onready var inv: Inv = preload("res://system/inventory/items/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
	
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
