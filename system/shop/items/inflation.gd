extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.FISH:
		var fish := object as Fish
		if my_level == 1:
			fish.point_value = fish.point_value * 1.25
		elif my_level == 2:
			fish.point_value = fish.point_value * 1.5
		elif my_level == 3:
			fish.point_value = fish.point_value * 2
			
