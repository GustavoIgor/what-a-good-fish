extends CanvasLayer

@export var  singular_slot : PackedScene
@onready var grid_container := $Panel/GridContainer
@onready var trade_slot := $Panel/TradeContainer/HBoxContainer/Slot

const SlotClass = preload("res://Scripts/slot.gd")

var fish_index: int = -1

func _ready() -> void:
	set_slots()
	_on_inventory_updated()
	for i in range(grid_container.get_child_count()):
		var slot: SlotClass = grid_container.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))

	InventoryManager.connect("inventory_updated", _on_inventory_updated)

func slot_gui_input(event: InputEvent, slot: SlotClass, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.data:
			trade_slot.set_data(slot.data)
			fish_index = slot_index
	if event.is_action_pressed("cancel"):
		cancel()

func cancel():
	fish_index = -1
	trade_slot.set_data(null)

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
		InventoryManager.remove_fish(fish_index)
		cancel()
