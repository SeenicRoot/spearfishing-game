class_name Augment
extends ShopItem

@export var level: int = 1:
	get: 
		return level
	set(value):
		level = value

@export var dict_level_description: Dictionary = {
}

func update_description(dict_level_description) -> String:
	description= str(dict_level_description)
	return description
	
