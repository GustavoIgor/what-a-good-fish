extends Resource
class_name EnemyResource

@export var name: String
@export var icon : Texture
@export var level: int
@export var hp: int
@export var attack: int
@export var defense: int

func take_damage(amount: int) -> int:
	var dmg = max(amount - defense, 0)
	hp = hp - dmg
	return dmg

func is_dead() -> bool:
	return hp <= 0

func generate_loot() -> Array:
	var loot: Array = []
	if randf() < 0.5:
		loot.append(preload("res://Resources/itens/small_potion.tres"))
	return loot
