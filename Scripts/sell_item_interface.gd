extends CanvasLayer
@export var singular_slot : PackedScene
@onready var grid := $Panel/GridContainer
@onready var trade_slot := $Panel/TradeContainer/HBoxContainer/ItemSlot

@onready var initial_label := $Panel/TradeContainer/InitialLabel
@onready var description_label := $Panel/TradeContainer/DescriptionLabel
@onready var price_label := $Panel/TradeContainer/PriceLabel
@onready var current_balance := $Panel/TradeContainer/CurrentBalance
@onready var sell_button := $Panel/TradeContainer/SellButton

const SlotClass = preload("res://Scripts/item_slot.gd")

var item_index: int = -1
var valor : float

func _ready() -> void:
	set_slots()
	_on_inventory_updated()
	for i in range(grid.get_child_count()):
		var slot: SlotClass = grid.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))
	Global.money_changed.connect(_on_money_changed)
	InventoryManager.connect("inventory_updated", _on_inventory_updated)
	_on_money_changed()
	analize_item()

func slot_gui_input(event: InputEvent, slot: SlotClass, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.data:
			trade_slot.set_data_singular(slot.data["item"])
			item_index = slot_index
			analize_item()
	if event.is_action_pressed("cancel"):
		cancel()

func cancel():
	item_index = -1
	trade_slot.set_data({})
	analize_item()
	valor = 0

func set_slots():
	for i in InventoryManager.item_capacity:
		grid.add_child(singular_slot.instantiate())

func _on_inventory_updated() -> void:
	for i in range(grid.get_child_count()):
		var slot: SlotClass = grid.get_child(i)
		var item: Dictionary = InventoryManager.get_item_at(i)
		if item:
			slot.set_data(item)
		else:
			slot.clear()

func analize_item():
	if trade_slot.data:
		valor = trade_slot.data["item"].price * 0.6
		initial_label.text = "It's a " + trade_slot.data["item"].name
		description_label.text = trade_slot.data["item"].description
		price_label.text = "I will buy it for " + str("%.2f" % valor) + "."
		sell_button.show()
	else:
		initial_label.text = ""
		description_label.text = ""
		price_label.text = ""
		sell_button.hide()

func _on_money_changed():
	current_balance.text = "Current balance: " + str("%.2f" % Global.money)

func _on_sell_button_pressed() -> void:
	if !trade_slot.data:
		return
	InventoryManager.remove_item_by_index(item_index)
	Global.change_money(valor)
	cancel()
