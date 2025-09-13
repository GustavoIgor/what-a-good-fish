extends Node

signal inventory_updated

const MAX_EXPANSION := 30
const EXPANSION_STEP := 10

var item_capacity: int = 10
var item_inventory: Array[Dictionary] = []

func _ready() -> void:
	item_inventory.resize(item_capacity)

func add_item(item: Item, quantity: int = 1) -> void:
	if item.stackable:
		for entry in item_inventory:
			if entry["item"].id == item.id:
				entry["quantity"] += quantity
				return
	item_inventory.append({ "item": item, "quantity": quantity })

func remove_item(item: Item, quantity: int = 1) -> void:
	for entry in item_inventory:
		if entry["item"].id == item.id:
			entry["quantity"] -= quantity
			if entry["quantity"] <= 0:
				item_inventory.erase(entry)
			return

func remove_item_byid(id : int):
	if id >= 0 and id < item_inventory.size():
		var f = item_inventory[id]
		item_inventory[id] = {}
		emit_signal("inventory_updated")
		return f
	return null

func swap_item(index_a: int, index_b: int) -> void:
	if index_a < 0 or index_a >= item_capacity:
		return
	if index_b < 0 or index_b >= item_capacity:
		return
	
	var entry_a = item_inventory[index_a]
	var entry_b = item_inventory[index_b]

	if entry_a["item"].id == entry_b["item"].id and entry_a["item"].stackable:
		entry_a["quantity"] += entry_b["quantity"]
		item_inventory.remove_at(index_b)
	else:
		item_inventory[index_a] = entry_b
		item_inventory[index_b] = entry_a

func expand_inventory() -> void:
	if item_capacity < MAX_EXPANSION:
		item_capacity += EXPANSION_STEP
		item_inventory.resize(item_capacity)
		emit_signal("inventory_updated")

func has_item(id: String, quantity: int = 1) -> bool:
	for entry in item_inventory:
		if entry["item"].id == id and entry["quantity"] >= quantity:
			return true
	return false

func get_items_by_type(item_type: String) -> Array[Dictionary]:
	#"ConsumableItem", "WeaponItem", "ArmorItem"
	return item_inventory.filter(func(entry): return entry["item"].get_class() == item_type)
