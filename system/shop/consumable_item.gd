class_name Consumable
extends ShopItem

@export var charges: int = 0

func add_charge() -> void:
	charges += 1
	
func use_item(event: InputEvent) -> void:
	pass
	
