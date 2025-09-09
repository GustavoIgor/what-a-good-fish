extends Panel
class_name InventorySlot

# Function to slots
# TODO show the data while hovering and modulate it for other types of items.

var data: FishData = null

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

func _ready() -> void:
	refresh()

func set_data(new_data: FishData) -> void:
	data = new_data
	refresh()

func clear() -> void:
	data = null
	refresh()

func refresh() -> void:
	if data:
		modulate = Color(1,1,1,1)
		icon.texture = data.icon
		label.text = data.name
	else:
		modulate = Color(1,1,1,0.5)
		icon.texture = null
		label.text = ""
