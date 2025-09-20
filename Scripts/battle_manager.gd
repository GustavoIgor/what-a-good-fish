extends CanvasLayer

enum BattleState { START, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var state: BattleState = BattleState.START

var enemy: EnemyResource

@export var item_slot : PackedScene
@onready var actions_panel = $BattlePanel/ActionsPanel
@onready var log_panel = $BattlePanel/LogPanel/ScrollContainer/RichTextLabel
@onready var loot_panel = $LootPanel

func start_battle(enemy_res: EnemyResource, back1 : Texture = null, back2 : Texture = null) -> void:
	$MovingBackGround.swap_backgrounds(back1, back2)
	log_panel.text = ""
	enemy = enemy_res
	%EnemyLabel.text = enemy.name
	%EnemyIcon.texture = enemy.icon
	%EnemyProgressBar.max_value = enemy.max_hp
	state = BattleState.PLAYER_TURN
	_log("A wild %s appeared!" % enemy.name)
	_update_ui()
	show()

func _update_ui() -> void:
	%HPProgressBar.value = Global.player_stats["hp"]
	%HPProgressBar.max_value = Global.player_stats["max_hp"]
	%StaminaProgressBar.value = Global.player_stats["stamina"]
	%StaminaProgressBar.max_value = Global.player_stats["max_stamina"]
	%HPLabel.text = "HP: " + str(Global.player_stats["hp"]) + "|" + str(Global.player_stats["max_hp"])
	%StaLabel.text = "STAMINA: " + str(Global.player_stats["stamina"]) + "|" + str(Global.player_stats["max_stamina"])
	%EnemyProgressBar.value = enemy.current_hp

func _log(text: String) -> void:
	log_panel.add_text(text + "\n")

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
	hide()

func _enemy_turn() -> void:
	var dmg = enemy.attack
	Global.change_hp(-enemy.attack)
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
		if loot:
			$LootPanel.show()
			for i in loot:
				var item = item_slot.instantiate()
				$LootPanel/GridContainer.add_child(item)
				item.set_data_singular(i)
		#_log("Loot: %s" + loot)
		# Aqui você mostra tela de loot
		
		#hide()
	else:
		_log("You were defeated...")
		hide()
		# Aqui você aplica a lógica de perder 3 itens e voltar para checkpoint
	actions_panel.hide()

func _on_attack_pressed() -> void:
	on_player_attack()

func _on_use_item_pressed() -> void:
	pass

func _on_flee_pressed() -> void:
	on_player_run()
