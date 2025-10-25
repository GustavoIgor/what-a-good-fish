extends TextureRect

signal item_use_canceled
signal item_used(item_name : String)

@export var item_slot : PackedScene
@export var item_grid_container : GridContainer

var item_index : int

const ITEM_SLOT_CLASS = preload("res://Scripts/item_slot.gd")

func _ready() -> void:
	set_slots()
	
	for i in range(item_grid_container.get_child_count()):
		var slot : ITEM_SLOT_CLASS = item_grid_container.get_child(i)
		slot.gui_input.connect(item_slot_gui_input.bind(slot, i))
	
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func item_slot_gui_input(event: InputEvent, slot: ITEM_SLOT_CLASS, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.data and slot.data["item"] is ConsumableItem:
			item_index = slot_index
			slot.modulate = Color(0.263, 0.263, 0.263, 1.0)
			$HBoxContainer/UseItem.show()
		else:
			$HBoxContainer/UseItem.hide()

func set_slots():
	for i in InventoryManager.item_capacity:
		item_grid_container.add_child(item_slot.instantiate())

func _on_inventory_updated() -> void:
	for i in range(item_grid_container.get_child_count()):
		var slot : ITEM_SLOT_CLASS = item_grid_container.get_child(i)
		var item : Dictionary = InventoryManager.get_item_at(i)
		if item:
			slot.set_data(item)
		else:
			slot.clear()

func use_item(i : int):
	InventoryManager.get_item_at(i)["item"].use()
	InventoryManager.remove_item_by_index(i)
	$HBoxContainer/UseItem.hide()

func _on_cancel_item_pressed() -> void:
	item_use_canceled.emit()

func _on_use_item_pressed() -> void:
	item_used.emit(InventoryManager.get_item_at(item_index)["item"].name)
	use_item(item_index)
