extends Node

#This is the inventory manager, this node will control ever fish caught

signal inventory_updated

#Inventory consts of max size and expansion step.
const MAX_EXPANSION := 30
const EXPANSION_STEP := 10

var fish_capacity: int = 10
var fish_inventory: Array = []

func _ready() -> void:
	fish_inventory.resize(fish_capacity)

# Func to add a fish (mostly used in fishing)
func add_fish(data) -> bool:
	for i in range(fish_capacity):
		if fish_inventory[i] == null:
			fish_inventory[i] = data
			emit_signal("inventory_updated")
			return true
	return false

# Function for fish remove (will use it on the shop)
func remove_fish(slot_index: int):
	if slot_index >= 0 and slot_index < fish_inventory.size():
		var f = fish_inventory[slot_index]
		fish_inventory[slot_index] = null
		emit_signal("inventory_updated")
		return f
	return null

# Fun to get fish
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
	emit_signal("inventory_updated")
	return true

# Function for inventory expansion (not used yet)
func expand_inventory() -> void:
	if fish_capacity < MAX_EXPANSION:
		fish_capacity += EXPANSION_STEP
		fish_inventory.resize(fish_capacity)
		emit_signal("inventory_updated")

# Function to get the quantity of fish
func get_fish_quantity():
	var fish_quantity = 0
	for i in range(fish_capacity):
		if fish_inventory[i] != null:
			fish_quantity += 1
	return fish_quantity
