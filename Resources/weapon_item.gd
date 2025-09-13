extends Item
class_name WeaponItem

@export var damage: int
@export var attack_speed: float
@export var durability: int

func _init() -> void:
	stackable = false
