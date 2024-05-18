extends Consumable

func apply_upgrade(object: Object):
	## get all types of fish from spawner, randomize it and store the type of fish to a variable
	if upgrade_type == UpgradeType.FISH:
		var fish := object as Fish
	
func use_item(event: InputEvent) -> void:
	event.is_action_pressed("w")
	if charges != 0:
		charges -= 1
		#stored variable .point_value * 2
