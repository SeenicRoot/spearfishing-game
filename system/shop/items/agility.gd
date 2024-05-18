extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		if my_level == 1:
			player.max_speed = player.max_speed * 1.1
		elif my_level == 2:
			player.max_speed = player.max_speed * 1.25
		elif my_level == 3:
			player.max_speed = player.max_speed * 1.5
			
