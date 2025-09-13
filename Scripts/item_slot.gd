extends TextureRect

@export var slot_index: int = -1
@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel
@onready var hover_panel: PanelContainer = $HoverPanel

var data: Dictionary = {}  # {"item": Item, "quantity": int}

func set_entry(new_data: Dictionary) -> void:
	data = new_data
	
	if data.is_empty():
		item_icon.texture = null
		quantity_label.text = ""
		hover_panel.visible = false
		return
	
	var item: Item = data["item"]
	item_icon.texture = item.icon
	quantity_label.text = str(data["quantity"]) if item.stackable else ""
	
	# Update hover information
	var hover_label: Label = hover_panel.get_node("MarginContainer/VBoxContainer/InfoLabel")
	hover_label.text = "%s\n%s" % [item.name, item.description]

func _on_mouse_entered() -> void:
	if not data.is_empty():
		hover_panel.visible = true

func _on_mouse_exited() -> void:
	hover_panel.visible = false
