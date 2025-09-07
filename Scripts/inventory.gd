extends CanvasLayer
@onready var inventory_icon := $InventoryIcon
@onready var inventory_panel := $InventoryPanel
@onready var grid_container := $InventoryPanel/GridContainer

const SlotClass = preload("res://Scripts/slot.gd")
var holding_item = null

var entered_inventory_icon := false

func _ready() -> void:
	for inv_slot in grid_container.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))
	inventory_panel.visible = false

func slot_gui_input(event : InputEvent, slot : SlotClass):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if holding_item != null:
			if !slot.item:
				slot.put_into_slot(holding_item)
				holding_item = null
				return
			else:
				var temp_item = slot.item
				slot.pick_from_slot()
				temp_item.global_position = get_viewport().get_mouse_position()
				slot.put_into_slot(holding_item)
				holding_item = temp_item
				return
		elif slot.item:
			holding_item = slot.item
			slot.pick_from_slot()
			holding_item.global_position = get_viewport().get_mouse_position()
			return

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false and entered_inventory_icon:
			inventory_panel.visible = !inventory_panel.visible
	if holding_item:
		holding_item.global_position = get_viewport().get_mouse_position()

func _on_inventory_icon_mouse_entered() -> void:
	entered_inventory_icon = true

func _on_inventory_icon_mouse_exited() -> void:
	entered_inventory_icon = false
