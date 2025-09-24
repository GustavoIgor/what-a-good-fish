extends Resource
class_name EnemyTable

@export var enemies: Array[EnemyEntry] = []

func get_enemy_for_level(level: int) -> Resource:
	var pool: Array = []
	for entry in enemies:
		if level >= entry.min_level and level <= entry.max_level:
			pool.append(entry.enemy_resource)
	if pool.is_empty():
		push_warning("No enemy available for level %s" % level)
		return null
	return pool.pick_random()
