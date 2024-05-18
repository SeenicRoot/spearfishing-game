extends Consumable

var object_ref: Player

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		object_ref = player
	
func use_item(event: InputEvent) -> void:
	event.is_action_pressed("q")
	if charges != 0:
		charges -= 1
		var tween := object_ref.get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 5)
		await tween.finished
