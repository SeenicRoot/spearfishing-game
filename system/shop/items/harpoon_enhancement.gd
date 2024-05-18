extends Augment

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		var harpoon_launcher := object as HarpoonLauncher
		if my_level == 1:
			#todo retract harpoon hits fishes
		elif my_level == 2:
			#todo shoots 2 harpoon at once
		elif my_level == 3:
			#todo each shoot from harpoon summons a net that catpures fish in a small radius
			
