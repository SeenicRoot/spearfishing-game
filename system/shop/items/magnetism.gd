extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var PLAYER := object as Player
		if my_level == 1:
			#todo suck up some fish near the player hitbox
		elif my_level == 2:
			#increase radius of my_level == 1
		elif my_level == 3:
			#increase radius of my_level == 2
			
