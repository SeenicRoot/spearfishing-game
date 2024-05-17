class_name Consumable
extends ShopItem

@export var charges: int = 0: get = _get_charges,  set = _set_charges
func _get_charges(): 
	return charges
func _set_charges(value : int):
	charges = value

func update_charges(charges) -> int:
	return charges + 1
	
