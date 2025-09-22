extends CanvasLayer

#This is the node to actually show the fish inventory

@export var fish_slot : PackedScene
@export var item_slot : PackedScene
@onready var fish_inventory_panel := $FishInventoryPanel
@onready var fish_grid_container := $FishInventoryPanel/GridContainer
@onready var item_inventory_panel := $ItemInventoryPanel
@onready var item_grid_container := $ItemInventoryPanel/GridContainer
@onready var drag_preview := $DragPreview

const FISH_SLOT_CLASS = preload("res://Scripts/slot.gd")
const ITEM_SLOT_CLASS = preload("res://Scripts/item_slot.gd")

var holding_from_index: int = -1
var holding_fish_data: FishData = null
var holding_item : Dictionary = {}
var entered_inventory_icon := false

func _ready() -> void:
	set_slots()
	# connect the slots
	for i in range(fish_grid_container.get_child_count()):
		var slot : FISH_SLOT_CLASS = fish_grid_container.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))
		slot.delete.connect(_on_fish_delete.bind(i))
	for i in range(item_grid_container.get_child_count()):
		var slot : ITEM_SLOT_CLASS = item_grid_container.get_child(i)
		slot.gui_input.connect(item_slot_gui_input.bind(slot, i))
		slot.delete.connect(_on_item_delete.bind(i))
		slot.use.connect(_on_use_item.bind(i))

	InventoryManager.connect("inventory_updated", _on_inventory_updated)
	fish_inventory_panel.visible = false
	drag_preview.visible = false
	_on_inventory_updated()

# The drag_preview is always following the cursor, and in the right moment will appear.
func _process(_delta: float) -> void:
	drag_preview.global_position = get_viewport().get_mouse_position()

# Manages the player interaction with the inventory.
func slot_gui_input(event: InputEvent, slot: FISH_SLOT_CLASS, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.util_panel.visible:
			return
		#If the player is holding a fish, swaps.
		if holding_fish_data:
			if InventoryManager.swap_fish(holding_from_index, slot_index):
				cancel_drag()
		else:
			#If player is not holding a fish, the player will hold the fish if there is any.
			if slot.data:
				holding_fish_data = slot.data
				holding_from_index = slot_index
				drag_preview.texture = slot.icon.texture
				drag_preview.visible = true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		slot.show_util_panel()

func item_slot_gui_input(event: InputEvent, slot: ITEM_SLOT_CLASS, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot.util_panel.visible:
			return
		if holding_item:
			if InventoryManager.swap_item(holding_from_index, slot_index):
				cancel_drag()
		else:
			if slot.data != {}:
				holding_item = slot.data
				holding_from_index = slot_index
				drag_preview.texture = slot.icon.texture
				drag_preview.visible = true
				
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		slot.show_util_panel()

func cancel_drag() -> void:
	holding_fish_data = null
	holding_from_index = -1
	holding_item = {}
	drag_preview.visible = false

# downloading the data in Inventory Manager
func _on_inventory_updated() -> void:
	for i in range(fish_grid_container.get_child_count()):
		var slot: FISH_SLOT_CLASS = fish_grid_container.get_child(i)
		var fish: FishData = InventoryManager.get_fish_at(i)
		if fish:
			slot.set_data(fish)
		else:
			slot.clear()
	for i in range(item_grid_container.get_child_count()):
		var slot : ITEM_SLOT_CLASS = item_grid_container.get_child(i)
		var item : Dictionary = InventoryManager.get_item_at(i)
		if item:
			slot.set_data(item)
		else:
			slot.clear()

func set_slots():
	for i in InventoryManager.fish_capacity:
		fish_grid_container.add_child(fish_slot.instantiate())
	for i in InventoryManager.item_capacity:
		item_grid_container.add_child(item_slot.instantiate())

#Functions for the icons

func _on_item_inventory_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		item_inventory_panel.visible = !item_inventory_panel.visible
		fish_inventory_panel.visible = false
		cancel_drag()

func _on_fish_inventory_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		fish_inventory_panel.visible = !fish_inventory_panel.visible
		item_inventory_panel.visible = false
		cancel_drag()

func _on_fish_delete(i : int):
	InventoryManager.remove_fish(i)

func _on_item_delete(i : int):
	InventoryManager.remove_item_by_index(i)

func _on_use_item(i : int):
	InventoryManager.get_item_at(i)["item"].use()
	InventoryManager.remove_item_by_index(i)
