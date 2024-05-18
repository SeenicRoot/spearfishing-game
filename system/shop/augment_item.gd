class_name Augment
extends ShopItem

@export var description_per_level: Array[String] = []
@export var cost_per_level: Array[int] = []
@export var my_level: int = 0 ## current power up level to apply ability
@export var level: int = 1: ## shop display for next power up level
	set(val):
		level = val
		my_level = level - 1

func get_description() -> String:
	return description_per_level[level - 1]
	
func get_cost() -> int:
	return cost_per_level[level - 1]

func increment_level() -> void:
	level += 1
