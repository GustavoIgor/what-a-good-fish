extends CanvasLayer

enum BattleState { START, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var state: BattleState = BattleState.START
var enemy: EnemyResource
var enemy_current_hp : int
var just_lose := false

@export var item_slot : PackedScene
@onready var actions_panel = $BattlePanel/ActionsPanel
@onready var log_panel = $BattlePanel/LogPanel/ScrollContainer/RichTextLabel
@onready var loot_panel = $LootPanel
@onready var use_item_panel = $UseItemPanel

func _ready() -> void:
	RandomEncounter.battle_triggered.connect(_on_battle_triggered)
	use_item_panel.item_use_canceled.connect(_on_use_item_canceled)
	use_item_panel.item_used.connect(on_player_use_item)

func start_battle(enemy_res: EnemyResource, back1 : Texture = null, back2 : Texture = null) -> void:
	Global.pause_game()
	SoundManager.play_music(preload("res://Assets/music/Fierce_battle_is_today.wav"), false, -10)
	$MovingBackGround.swap_backgrounds(back1, back2)
	log_panel.text = ""
	enemy = enemy_res.duplicate()
	%EnemyLabel.text = enemy.name
	%EnemyIcon.texture = enemy.icon
	%EnemyProgressBar.max_value = enemy.hp
	%HPProgressBar.max_value = Global.player_stats["max_hp"]
	%StaminaProgressBar.max_value = Global.player_stats["max_stamina"]
	state = BattleState.PLAYER_TURN
	_log("A wild %s appeared!" % enemy.name)
	_update_ui()
	show()

func _on_battle_triggered(enemy_tri : EnemyResource):
	start_battle(enemy_tri)

func _update_ui() -> void:
	%HPProgressBar.value = Global.player_stats["hp"]
	%StaminaProgressBar.value = Global.player_stats["stamina"]
	%HPLabel.text = "HP: " + str(Global.player_stats["hp"]) + "|" + str(Global.player_stats["max_hp"])
	%StaLabel.text = "STAMINA: " + str(Global.player_stats["stamina"]) + "|" + str(Global.player_stats["max_stamina"])
	%EnemyProgressBar.value = enemy.hp

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

func on_player_use_item(item_name) -> void:
	use_item_panel.hide()
	_update_ui()
	_log("You used %s!" % item_name)
	state = BattleState.ENEMY_TURN
	await get_tree().create_timer(1.0).timeout
	_enemy_turn()

func on_player_run() -> void:
	_log("You ran away...")
	await get_tree().create_timer(1.0).timeout
	Global.unpause_game()
	hide()
	SoundManager.check_music()

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
	Global.unpause_game()
	if victory:
		_log("You defeated %s!" % enemy.name)
		var loot = enemy.generate_loot()
		$BattlePanel.hide()
		$LootPanel.show()
		if loot:
			for i in loot:
				var item = item_slot.instantiate()
				$LootPanel/GridContainer.add_child(item)
				item.set_data_singular(i)
				InventoryManager.add_item(i)
				_log("Loot: " + i.name)
	else:
		just_lose = true
		_log("You were defeated...")
		# Lose some random items as penalty
		_lose_random_items(3)
		# Return player to the last shop level (levels that end with 5: 5,15,25...)
		var current_level = Global.level
		var shop_level = int(floor(float(current_level - 5) / 10.0) * 10 + 5)
		hide()
		Global.player_stats["hp"] = Global.player_stats["max_hp"]
		if shop_level < 5:
			Global.level = 0
			Fade.fade_transition("") #Put initial scene here
		Global.level = shop_level
		# Hide battle UI and go to shop scene
		Fade.fade_transition("res://Scenes/shop_zone.tscn")

func _on_attack_pressed() -> void:
	on_player_attack()

func _on_use_item_pressed() -> void:
	$UseItemPanel.show()

func _on_use_item_canceled():
	$UseItemPanel.hide()


func _on_flee_pressed() -> void:
	on_player_run()

func _on_ok_pressed() -> void:
	for i in $LootPanel/GridContainer.get_children():
		$LootPanel/GridContainer.remove_child(i)
	$LootPanel.hide()
	$BattlePanel.show()
	enemy = null
	hide()
	SoundManager.check_music()


func _lose_random_items(count: int) -> void:
	# Collect indices of non-empty item slots
	var filled_indices: Array = []
	for i in range(InventoryManager.item_inventory.size()):
		if InventoryManager.item_inventory[i] != {}:
			filled_indices.append(i)
	if filled_indices.is_empty():
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var removed := 0
	while removed < count and filled_indices.size() > 0:
		var pick_idx = rng.randi_range(0, filled_indices.size() - 1)
		var slot = filled_indices[pick_idx]
		# Remove one quantity from that slot (if stackable it will decrement)
		var entry = InventoryManager.get_item_at(slot)
		if entry != {}:
			var item_name = entry["item"].name
			InventoryManager.remove_item_by_index(slot, 1)
			_log("Lost item: %s" % item_name)
			removed += 1
		# remove the index from candidates so we don't pick it again
		filled_indices.erase(pick_idx)
