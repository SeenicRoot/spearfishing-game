extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		var harpoon_launcher := object as HarpoonLauncher
		if my_level == 1:
			harpoon_launcher.harpoon_collision_shape.Shape.Radius = 8
		elif my_level == 2:
			harpoon_launcher.harpoon_range_ratio = 1.5
		elif my_level == 3:
			harpoon_launcher.harpoon_speed = harpoon_launcher.harpoon_speed * 1.5
			
