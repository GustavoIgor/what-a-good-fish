extends CanvasLayer

enum BattleState { START, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var state: BattleState = BattleState.START

var enemy: EnemyResource

@onready var ui_status = $StatusPanel
@onready var ui_actions = $ActionPanel
@onready var ui_log = $LogPanel/RichTextLabel

func start_battle(enemy_res: EnemyResource) -> void:
	enemy = enemy_res
	state = BattleState.PLAYER_TURN
	_log("A wild %s appeared!" % enemy.name)
	_update_ui()

func _update_ui() -> void:
	pass

func _log(text: String) -> void:
	ui_log.add_text(text + "\n")

# TURNS
func on_player_attack() -> void:
	if state != BattleState.PLAYER_TURN:
		return
	var dmg = enemy.take_damage(Global.player_attack())
	_log("You hit %s for %d damage!" % [enemy.name, dmg])
	if enemy.is_dead():
		state = BattleState.VICTORY
		_end_battle(true)
	else:
		state = BattleState.ENEMY_TURN
		await get_tree().create_timer(1.0).timeout
		_enemy_turn()

func on_player_use_item(item) -> void:
	# Placeholder: depois conecta inventário
	_log("You used %s!" % item.name)
	state = BattleState.ENEMY_TURN
	await get_tree().create_timer(1.0).timeout
	_enemy_turn()

func on_player_run() -> void:
	_log("You ran away...")
	queue_free()

func _enemy_turn() -> void:
	var dmg = Global.change_hp(-enemy.attack)
	_log("%s hits you for %d damage!" % [enemy.name, dmg])
	if Global.player_stats["hp"] == 0:
		state = BattleState.DEFEAT
		_end_battle(false)
	else:
		state = BattleState.PLAYER_TURN
		_update_ui()

func _end_battle(victory: bool) -> void:
	if victory:
		_log("You defeated %s!" % enemy.name)
		var loot = enemy.generate_loot()
		_log("Loot: %s" % loot)
		# Aqui você mostra tela de loot
	else:
		_log("You were defeated...")
		# Aqui você aplica a lógica de perder 3 itens e voltar para checkpoint
	ui_actions.hide()
