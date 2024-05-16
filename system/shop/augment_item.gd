class_name Augment
extends ShopItem

@export var level: int = 1

@export var dict_level_description: Dictionary = {
}

func update_description(dict_level_description) -> String:
	description= str(dict_level_description)
	return description
	
