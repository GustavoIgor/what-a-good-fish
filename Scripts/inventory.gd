extends CanvasLayer

#This is the node to actually show the fish inventory

@onready var inventory_icon := $InventoryIcon
@onready var inventory_panel := $InventoryPanel
@onready var grid_container := $InventoryPanel/GridContainer
@onready var drag_preview := $DragPreview

const SlotClass = preload("res://Scripts/slot.gd")

var holding_from_index: int = -1
var holding_data: FishData = null
var entered_inventory_icon := false

func _ready() -> void:
	# connect the slots
	for i in range(grid_container.get_child_count()):
		var slot: SlotClass = grid_container.get_child(i)
		slot.gui_input.connect(slot_gui_input.bind(slot, i))

	InventoryManager.connect("inventory_updated", _on_inventory_updated)
	inventory_panel.visible = false
	drag_preview.visible = false
	_on_inventory_updated()

# The drag_preview is always following the cursor, and in the right moment will appear.
func _process(delta: float) -> void:
	drag_preview.global_position = get_viewport().get_mouse_position()

# Manages the player interaction with the inventory.
func slot_gui_input(event: InputEvent, slot: SlotClass, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#If the player is holding a fish, swaps.
		if holding_data:
			if InventoryManager.swap_fish(holding_from_index, slot_index):
				cancel_drag()
		else:
			#If player is not holding a fish, the player will hold the fish if there is any.
			if slot.data:
				holding_data = slot.data
				holding_from_index = slot_index
				drag_preview.texture = slot.icon.texture
				drag_preview.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Clicking in the inventory icon make the panel visible (if it isn't) or invisible (if it is).
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and entered_inventory_icon:
			inventory_panel.visible = !inventory_panel.visible
			# Making the player throw the holding item away.
			cancel_drag()

func cancel_drag() -> void:
	holding_data = null
	holding_from_index = -1
	drag_preview.visible = false

# downloading the data in Inventory Manager
func _on_inventory_updated() -> void:
	for i in range(grid_container.get_child_count()):
		var slot: SlotClass = grid_container.get_child(i)
		var fish: FishData = InventoryManager.get_fish_at(i)
		if fish:
			slot.set_data(fish)
		else:
			slot.clear()

#Functions for the icon
func _on_inventory_icon_mouse_entered() -> void:
	entered_inventory_icon = true

func _on_inventory_icon_mouse_exited() -> void:
	entered_inventory_icon = false
