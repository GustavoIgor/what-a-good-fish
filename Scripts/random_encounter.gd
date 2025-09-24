extends Node
@export var enemy_table: EnemyTable
@export var steps_min: int = 500
@export var steps_max: int = 1500
@export var chance_per_step: float = 0.2

var step_counter: int = 0
var next_encounter_threshold: int

signal battle_triggered(enemy: Resource)

func _ready():
	_reset_counter()

func register_time():
	step_counter += 1
	if Global.is_in_battle:
		return
	
	if step_counter >= next_encounter_threshold:
		if randf() < chance_per_step or step_counter >= steps_max:
			_trigger_battle()

func _trigger_battle():
	var enemy = enemy_table.get_enemy_for_level(Global.level)
	if enemy:
		emit_signal("battle_triggered", enemy)
	_reset_counter()

func _reset_counter():
	step_counter = 0
	next_encounter_threshold = randi_range(steps_min, steps_max)
