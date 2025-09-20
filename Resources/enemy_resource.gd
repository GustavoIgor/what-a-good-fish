extends Resource
class_name EnemyResource

@export var name: String = "Bat"
@export var icon : Texture
@export var level: int = 1
@export var max_hp: int = 10
@export var attack: int = 3
@export var defense: int = 1

var current_hp: int

func _init():
	current_hp = max_hp

func take_damage(amount: int) -> int:
	var dmg = max(amount - defense, 0)
	current_hp = clamp(current_hp - dmg, 0, max_hp)
	return dmg

func is_dead() -> bool:
	return current_hp <= 0

func generate_loot() -> Array:
	var loot: Array = []
	if randf() < 0.5:
		loot.append(preload("res://Resources/itens/small_potion.tres"))
	return loot
