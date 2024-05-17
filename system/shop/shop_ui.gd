extends Control

@export var total_points: Label
@export var title: Label
@export var level: Label

@export var item_description: RichTextLabel
@export var charges = Label
@export var cost = Label
@export var buy = Button

var selected_item: ShopItem

@onready var shop: Shop = preload("res://system/shop/shop.tres")
@onready var items: Array = $LeftContainer/GridContainer.get_children()
@onready var item_visual: TextureRect = $RightContainer/VBoxContainer/ShopItem/MarginContainer/ItemDisplay

var my_points: int = 1000

func _ready():
	connect_shop_items()
	update()
	buy.pressed.connect(buy_selected_item)
	select_item(items[0].item_ref)

func connect_shop_items():
	for item in items:
		item.pressed.connect(func(): select_item(item.item_ref))
	

func update():
	for i in range(min(shop.items.size(), items.size())):
		items[i].update(shop.items[i])
		
	
func select_item(item: ShopItem):
	total_points.text = str(my_points)
	selected_item = item
	title.text = selected_item.name
	if my_points < selected_item.cost:
		buy.modulate = "000000"
		buy.disabled = true
	else: 
		buy.modulate = "ffffff"
		buy.disabled = false
	item_visual.texture = selected_item.texture
	if selected_item is Augment:
		level.visible = true
		charges.visible = false
		level.text = "Lvl " + str(selected_item.level)
		if selected_item.level == 3: ## Max level
			buy.text = "Max level reached"
			buy.disabled = true
		else:
			buy.text = "Buy"
	elif selected_item is Consumable: ## Consummable
		level.visible = false
		charges.visible = true
		charges.text = "Charges: " + str(selected_item.charges)
	item_description.text = selected_item.description
	cost.text = "$" + str(selected_item.cost)
	
func buy_selected_item():
	my_points -= selected_item.cost
	if selected_item is Augment:
		selected_item.increment_level()
	elif selected_item is Consumable: 
		selected_item.add_charge()
	select_item(selected_item)
