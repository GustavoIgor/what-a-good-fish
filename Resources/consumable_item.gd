extends Item
class_name ConsumableItem

@export var heal_amount: int = 0
@export var stamina_restore: int = 0

func use(target) -> void:
	Global.change_stamina(stamina_restore)
