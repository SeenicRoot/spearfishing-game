extends Consumable

var object_ref: Player

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		object_ref = player
	
func use_item(event: InputEvent) -> void:
	event.is_action_pressed("r")
	#todo time stop
