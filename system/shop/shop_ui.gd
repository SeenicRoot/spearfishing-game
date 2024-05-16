extends Control

@onready var shop: Shop = preload("res://system/shop/shop.tres")
@onready var items: Array = $LeftContainer/GridContainer.get_children()
@onready var detail = $RightContainer
@onready var selected_item = $RightContainer/VBoxContainer/ShopItem 
@onready var level = $RightContainer/VBoxContainer/Level
@onready var item_visual: TextureRect = $RightContainer/VBoxContainer/ShopItem/MarginContainer/ItemDisplay
@onready var item_description: = $RightContainer/VBoxContainer/MarginContainer/Description
@onready var charges = $RightContainer/VBoxContainer/Charges
@onready var cost = $RightContainer/VBoxContainer/Cost
@onready var buy = $RightContainer/VBoxContainer/Buy

func _ready():
	connect_shop_items()
	update()
	detail.visible = false
	

func connect_shop_items():
	for item in items:
		item.pressed.connect(func (): select_item(item.item_ref))
	

func update():
	for i in range(min(shop.items.size(), items.size())):
		items[i].update(shop.items[i])
		
	
func select_item(item: ShopItem):
	detail.visible = true
	selected_item = item
	item_visual.texture = selected_item.texture
	if selected_item is Augment:
		level.visible = true
		charges.visible = false
		level.text = "Lvl " + str(selected_item.level)
		item_description.text = selected_item.update_description(selected_item.dict_level_description.get(selected_item.level))
	else: ## consummable
		level.visible = false
		charges.visible = true
	cost.text = "$" + str(selected_item.cost)
	buy.pressed.connect(buy_selected_item)
	
func buy_selected_item():
	pass
