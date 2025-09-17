extends Node

#This is the inventory manager, this node will control ever fish caught

signal inventory_updated
signal inventory_expanded(inv)

#Inventory consts of max size and expansion step.
const MAX_EXPANSION := 30
const EXPANSION_STEP := 10

var fish_capacity := 10
var item_capacity := 10
var fish_inventory : Array = []
var item_inventory: Array[Dictionary] = []

func _ready() -> void:
	fish_inventory.resize(fish_capacity)
	item_inventory.resize(item_capacity)

# FISH INVENTORY MANAGEMENT

# Func to add a fish (mostly used in fishing)
func add_fish(data) -> bool:
	for i in range(fish_capacity):
		if fish_inventory[i] == null:
			fish_inventory[i] = data
			inventory_updated.emit()
			return true
	return false

# Function for fish remove (will use it on the shop)
func remove_fish(slot_index: int):
	if slot_index >= 0 and slot_index < fish_inventory.size():
		var f = fish_inventory[slot_index]
		fish_inventory[slot_index] = null
		inventory_updated.emit()
		return f
	return null

# Function to get fish
func get_fish_at(slot_index: int):
	return fish_inventory[slot_index] if slot_index >= 0 and slot_index < fish_inventory.size() else null

# Swap, with various verifications
func swap_fish(from_index: int, to_index: int) -> bool:
	if from_index == to_index:
		return false
	if from_index < 0 or to_index < 0:
		return false
	if from_index >= fish_inventory.size() or to_index >= fish_inventory.size():
		return false

	var tmp = fish_inventory[to_index]
	fish_inventory[to_index] = fish_inventory[from_index]
	fish_inventory[from_index] = tmp
	inventory_updated.emit()
	return true

# Function to get the quantity of fish
func get_fish_quantity():
	var fish_quantity = 0
	for i in range(fish_capacity):
		if fish_inventory[i] != null:
			fish_quantity += 1
	return fish_quantity

# ITEM INVENTORY MANAGEMENT

# Func to add a item
func add_item(item: Item, quantity: int = 1) -> bool:
	if item.stackable:
		for entry in item_inventory:
			if entry != {}:
				if entry["item"].id == item.id:
					entry["quantity"] += quantity
					inventory_updated.emit()
					return true
	for i in range(item_capacity):
		if item_inventory[i] == {}:
			item_inventory[i] = { "item": item, "quantity": quantity }
			inventory_updated.emit()
			return true
	return false

func remove_item(item: Item, quantity: int = 1) -> void:
	for entry in item_inventory:
		if entry["item"].name == item.name:
			entry["quantity"] -= quantity
			if entry["quantity"] <= 0:
				item_inventory.erase(entry)
				inventory_updated.emit()
			return

func remove_item_by_index(index : int, quantity: int = 1):
	if item_inventory[index]:
		item_inventory[index]["quantity"] -= quantity
		if item_inventory[index]["quantity"] <= 0:
			item_inventory[index] = {}
		inventory_updated.emit()
		return

func swap_item(from_index: int, to_index: int) -> bool:
	if from_index == to_index:
		return false
	if from_index < 0 or to_index < 0:
		return false
	if from_index >= item_inventory.size() or to_index >= item_inventory.size():
		return false

	var tmp = item_inventory[to_index]
	item_inventory[to_index] = item_inventory[from_index]
	item_inventory[from_index] = tmp
	inventory_updated.emit()
	return true

func get_item_at(slot_index: int):
	return item_inventory[slot_index] if slot_index >= 0 and slot_index < item_inventory.size() else {}

func has_item(id: String, quantity: int = 1) -> bool:
	for entry in item_inventory:
		if entry["item"].id == id and entry["quantity"] >= quantity:
			return true
	return false

func get_items_by_type(item_type: String) -> Array[Dictionary]:
	#"ConsumableItem", "WeaponItem", "ArmorItem"
	return item_inventory.filter(func(entry): return entry["item"].get_class() == item_type)


# Function for inventory expansion (not used yet)
func expand_inventory(inv : String) -> void:
	if inv == "fish":
		if fish_capacity < MAX_EXPANSION:
			fish_capacity += EXPANSION_STEP
			fish_inventory.resize(fish_capacity)
			inventory_updated.emit()
			inventory_expanded.emit("fish")
	elif inv == "item":
		if item_capacity < MAX_EXPANSION:
			item_capacity += EXPANSION_STEP
			item_inventory.resize(item_capacity)
			inventory_updated.emit()
			inventory_expanded.emit("item")
