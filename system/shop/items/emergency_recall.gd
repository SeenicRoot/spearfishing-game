extends Consumable

var object_ref: Player

func apply_upgrade(object: Object):
	if upgrade_type == UpgradeType.PLAYER:
		var player := object as Player
		object_ref = player
	
func use_item(event: InputEvent) -> void:
	event.is_action_pressed("e")
	if charges != 0:
		charges -= 1
		var velocity = Vector2.UP * object_ref.PANIC_SPEED
		object_ref.rotate_player(Vector2.UP)
		#do the same thing for is panicked function from player
