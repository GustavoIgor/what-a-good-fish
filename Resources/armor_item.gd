# ArmorItem.gd
extends Item
class_name ArmorItem

@export var defense: int
@export var slot: String # "head", "chest", "legs"

func _init() -> void:
	stackable = false
