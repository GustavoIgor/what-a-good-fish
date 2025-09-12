extends CanvasLayer

@export var  singular_slot : PackedScene
@onready var grid_container := $Panel/GridContainer
@onready var trade_slot := $Panel/TradeContainer/HBoxContainer/Slot

@onready var initial_label := $Panel/TradeContainer/InitialLabel
@onready var impressions_label := $Panel/TradeContainer/ImpressionsLabel
@onready var price_label := $Panel/TradeContainer/PriceLabel
@onready var sell_button := $Panel/TradeContainer/SellButton

const SlotClass = preload("res://Scripts/slot.gd")

var fish_index: int = -1
var valor := 0.0

func _ready() -> void:
	set_slots()
	_on_inventory_updated()
	for i in range(grid_container.get_child_count()):
		var slot: SlotClass = grid_container.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))

	InventoryManager.connect("inventory_updated", _on_inventory_updated)
	analize_fish()

func slot_gui_input(event: InputEvent, slot: SlotClass, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.data:
			trade_slot.set_data(slot.data)
			fish_index = slot_index
			analize_fish()
	if event.is_action_pressed("cancel"):
		cancel()

func cancel():
	fish_index = -1
	trade_slot.set_data(null)
	analize_fish()

func set_slots():
	for i in InventoryManager.fish_capacity:
		grid_container.add_child(singular_slot.instantiate())

func _on_inventory_updated() -> void:
	for i in range(grid_container.get_child_count()):
		var slot: SlotClass = grid_container.get_child(i)
		var fish: FishData = InventoryManager.get_fish_at(i)
		if fish:
			slot.set_data(fish)
		else:
			slot.clear()


func _on_sell_button_pressed() -> void:
	if fish_index != -1:
		Global.change_money(valor)
		InventoryManager.remove_fish(fish_index)
		cancel()

func analize_fish():
	if fish_index == -1:
		initial_label.text = "I want to buy those fish, let me look at it"
		impressions_label.text = ""
		price_label.text = ""
		sell_button.hide()
		return

	var fish_data: FishData = InventoryManager.get_fish_at(fish_index)
	initial_label.text = "Hm... let's see..."
	
	# Rarity impression
	var rarity_impression: String
	match fish_data.rarity:
		1:
			rarity_impression = "It's pretty common..."
		2:
			rarity_impression = "It's a little interesting..."
		3:
			rarity_impression = "Wow, that's something..."
		4:
			rarity_impression = "Great... In a great shape too!"
		5:
			rarity_impression = "Where... where did you find it? It's majestic!"

	# Weight impression based on the new weight ranges
	var weight_impression: String
	if fish_data.weight >= 0.1 and fish_data.weight < 0.5:
		weight_impression = "It's very small and light..."
	elif fish_data.weight >= 0.5 and fish_data.weight < 2.0:
		weight_impression = "It's pretty light..."
	elif fish_data.weight >= 2.0 and fish_data.weight < 10.0:
		weight_impression = "It's a good weight..."
	elif fish_data.weight >= 10.0 and fish_data.weight < 50.0:
		weight_impression = "And it's quite large!"
	elif fish_data.weight >= 50.0:
		weight_impression = "And it's absolutely massive!"
	else:
		weight_impression = "It's an unusual size..."

	impressions_label.text = rarity_impression + " " + weight_impression

	# Calculate price based on rarity and weight
	valor = fish_data.rarity * (100 + fish_data.weight)
	price_label.text = "My price is: " + str("%.2f" % valor)
	sell_button.show()
