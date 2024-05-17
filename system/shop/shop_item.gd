class_name ShopItem
extends Resource

@export var name: String = "": get = _get_name,  set = _set_name
func _get_name(): 
	return name
func _set_name(value : String):
	name = value
		
@export var texture: Texture2D

@export_multiline var description: String = "": get = _get_description,  set = _set_description
func _get_description(): 
	return description
func _set_description(value : String):
	description = value
		
@export var cost: int = 0: get = _get_cost,  set = _set_cost
func _get_cost(): 
	return cost
func _set_cost(value : int):
	cost = value
