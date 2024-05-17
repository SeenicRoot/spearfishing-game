class_name Augment
extends ShopItem

@export var level: int = 1: get = _get_level,  set = _set_level
func _get_level(): 
	return level
func _set_level(value : int):
	level = value

@export var dict_level_description: Dictionary = {}

func update_level(level) -> int:
	return level + 1

func update_description(dict_level_description) -> String:
	description = str(dict_level_description)
	return description
	
func update_cost(level) -> int:
	var cost_factor = level * 5
	cost = cost * cost_factor
	return cost
