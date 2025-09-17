extends CanvasLayer

@export var singular_slot : PackedScene
@onready var grid := $Panel/GridContainer
@onready var trade_slot := $Panel/TradeContainer/HBoxContainer/ItemSlot

@onready var initial_label := $Panel/TradeContainer/InitialLabel
@onready var description_label := $Panel/TradeContainer/DescriptionLabel
@onready var price_label := $Panel/TradeContainer/PriceLabel
@onready var current_balance := $Panel/TradeContainer/CurrentBalance
@onready var buy_button := $Panel/TradeContainer/BuyButton

const SlotClass = preload("res://Scripts/item_slot.gd")

var item_index: int = -1
var on_sale_itens : Array[Dictionary]

func _ready() -> void:
	check_sale_itens()
	set_slots()
	for i in range(grid.get_child_count()):
		var slot: SlotClass = grid.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))
	Global.money_changed.connect(_on_money_changed)
	_on_money_changed()
	analize_item()

func check_sale_itens():
	on_sale_itens.append(
		{
			"item" : preload("res://Resources/itens/small_potion.tres"),
			"quantity" : 1
		}
	)

func slot_gui_input(event: InputEvent, slot: SlotClass, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.data:
			trade_slot.set_data(slot.data)
			item_index = slot_index
			analize_item()
	if event.is_action_pressed("cancel"):
		cancel()

func cancel():
	item_index = -1
	trade_slot.set_data({})
	analize_item()

func set_slots():
	for i in on_sale_itens.size():
		var slot := singular_slot.instantiate()
		grid.add_child(slot)
		slot.set_data(on_sale_itens[i])

func analize_item():
	if trade_slot.data:
		initial_label.text = "It's a " + trade_slot.data["item"].name
		description_label.text = trade_slot.data["item"].description
		price_label.text = "I will sell it for " + str("%.2f" % trade_slot.data["item"].price) + "."
		buy_button.show()
	else:
		initial_label.text = ""
		description_label.text = ""
		price_label.text = ""
		buy_button.hide()

func _on_money_changed():
	current_balance.text = "Current balance: " + str("%.2f" % Global.money)

func _on_buy_button_pressed() -> void:
	if !trade_slot.data:
		return
	if trade_slot.data["item"].price > Global.money:
		initial_label.text = "Not enough money"
		return
	InventoryManager.add_item(trade_slot.data["item"])
	Global.change_money(-trade_slot.data["item"].price)
	cancel()
