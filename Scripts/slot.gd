extends Panel

var item_class = preload("res://Scenes/fish.tscn")
var item = null

func _ready() -> void:
	if randi() % 2 == 1:
		item = item_class.instantiate()
		add_child(item)
	refresh_style()

func refresh_style():
	if item == null:
		self.modulate = Color(1, 1, 1, 0.5)
	else:
		self.modulate = Color(1, 1, 1, 1)

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()
