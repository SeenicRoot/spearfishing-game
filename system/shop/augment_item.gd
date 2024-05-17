class_name Augment
extends ShopItem


@export var description_per_level: Array[String] = []
@export var cost_per_level: Array[int] = []
@export var level: int = 1:
	set(val):
		level = val

func get_description() -> String:
	return description_per_level[level - 1]
	
func get_cost() -> int:
	return cost_per_level[level - 1]

func increment_level() -> void:
	level += 1
