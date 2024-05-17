extends Button

@onready var item_visual: TextureRect = $MarginContainer/ItemDisplay
var item_ref: ShopItem

func update(item: ShopItem):
	if !item:
		item_visual.visible = false
	else:
		item_ref = item
		item_visual.visible = true
		item_visual.texture = item.texture
		

