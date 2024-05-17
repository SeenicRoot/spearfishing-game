extends Control

@onready var shop: Shop = preload("res://system/shop/shop.tres")
@onready var items: Array = $LeftContainer/GridContainer.get_children()
@onready var detail = $RightContainer
@onready var total_points = $RightContainer/VBoxContainer/TotalPoints
@onready var selected_item = $RightContainer/VBoxContainer/ShopItem 
@onready var level = $RightContainer/VBoxContainer/Level
@onready var item_visual: TextureRect = $RightContainer/VBoxContainer/ShopItem/MarginContainer/ItemDisplay
@onready var item_description: = $RightContainer/VBoxContainer/MarginContainer/Description
@onready var charges = $RightContainer/VBoxContainer/Charges
@onready var cost = $RightContainer/VBoxContainer/Cost
@onready var buy = $RightContainer/VBoxContainer/Buy

var my_points: int = 300

func _ready():
	connect_shop_items()
	update()
	detail.visible = false
	buy.pressed.connect(buy_selected_item)
	

func connect_shop_items():
	for item in items:
		item.pressed.connect(func(): select_item(item.item_ref))
	

func update():
	for i in range(min(shop.items.size(), items.size())):
		items[i].update(shop.items[i])
		
	
func select_item(item: ShopItem):
	total_points.text = str(my_points)
	selected_item = item
	if my_points < selected_item.cost:
		buy.modulate = "000000"
		buy.disabled = true
	else: 
		buy.modulate = "ffffff"
		buy.disabled = false
	detail.visible = true
	item_visual.texture = selected_item.texture
	if selected_item is Augment:
		level.visible = true
		charges.visible = false
		level.text = "Lvl " + str(selected_item.level)
		if selected_item.level == 3: #max level
			buy.text = "Max level reached"
			buy.disabled = true
		else:
			buy.text = "Buy"
		item_description.text = selected_item.update_description(selected_item.dict_level_description.get(selected_item.level))
	else: ## consummable
		level.visible = false
		charges.visible = true
	cost.text = "$" + str(selected_item.cost)
	
func buy_selected_item():
	if selected_item is Augment:
		selected_item.level += 1
	else: 
		selected_item.charges += 1
	my_points -= selected_item.cost
	select_item(selected_item)
