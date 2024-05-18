extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		if my_level == 1:
			pass #TODO Shiny Fish
		elif my_level == 2:
			pass #TODO Shiny Fish
		elif my_level == 3:
			pass #TODO Shiny Fish
		
