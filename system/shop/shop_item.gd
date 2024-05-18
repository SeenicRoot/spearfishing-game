class_name ShopItem
extends Resource

enum UpgradeType {
	PLAYER,
	FISH
}

@export var upgrade_type: UpgradeType
@export var name: String = ""
@export var texture: Texture2D
@export_multiline var description: String:
	get = get_description
@export var cost: int = 0:
	get = get_cost

func get_description() -> String:
	return description
	
func get_cost() -> int:
	return cost

func apply_upgrade(object: Object) -> void:
	pass
