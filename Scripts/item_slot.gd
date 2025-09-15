extends TextureRect

@export var slot_index := -1
@onready var icon := $Icon
@onready var quantity_label := $QuantityLabel
@onready var hover_panel := $HoverPanel

var data: Dictionary = {}  # {"item": Item, "quantity": int}
var show_it := false

func _ready() -> void:
	refresh()

func set_data(new_data: Dictionary) -> void:
	data = new_data
	refresh()

func clear() -> void:
	data = {}
	refresh()

func refresh() -> void:
	if data:
		modulate = Color(1,1,1,1)
		icon.texture = data["item"].icon
		var item: Item = data["item"]
		icon.texture = item.icon
		quantity_label.text = str(data["quantity"]) if item.stackable else ""
	
		# Update hover information
		
		if data["item"] == WeaponItem:
			pass
		
	else:
		modulate = Color(1,1,1,0.5)
		icon.texture = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_it"):
		show_it = true
	if event.is_action_released("show_it"):
		show_it = false

func _on_mouse_entered() -> void:
	if data != null and show_it:
		hover_panel.visible = true

func _on_mouse_exited() -> void:
	hover_panel.visible = false
