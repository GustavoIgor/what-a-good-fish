extends CanvasLayer

@onready var money_label := $Panel/HBoxContainer/MoneyBoxContainer/MoneyLabel
@onready var stamina_progress_bar := $Panel/HBoxContainer/StaminaBoxContainer/ProgressBar
@onready var stamina_label := $Panel/HBoxContainer/StaminaBoxContainer/ProgressBar/Label
@onready var hp_progress_bar := $Panel/HBoxContainer/HPBoxContainer/ProgressBar
@onready var hp_label := $Panel/HBoxContainer/HPBoxContainer/ProgressBar/Label
@onready var level_label := $Panel/HBoxContainer/LevelBoxContainer/LevelLabel
@onready var fish_label := $Panel/HBoxContainer/FishBoxContainer/FishLabel
func _ready() -> void:
	Global.game_paused.connect(_on_game_paused)
	Global.game_unpaused.connect(_on_game_unpaused)
	Global.money_changed.connect(_on_money_changed)
	stamina_progress_bar.max_value = Global.player_stats["max_stamina"]
	Global.stamina_changed.connect(_on_stamina_changed)
	hp_progress_bar.max_value = Global.player_stats["max_hp"]
	Global.hp_changed.connect(_on_hp_changed)
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	
	if Global.level <= 0:
		$Retry.hide()
	
	level_label.text = "LEVEL: " + str(Global.level)
	_on_money_changed()
	_on_stamina_changed()
	_on_inventory_updated()
	_on_hp_changed()

func _on_money_changed():
	money_label.text = "MONEY: " + str("%.2f" % Global.money)
	
func _on_stamina_changed():
	stamina_progress_bar.value = Global.player_stats["stamina"]

func _on_hp_changed():
	hp_progress_bar.value = Global.player_stats["hp"]
	

func _on_inventory_updated():
	fish_label.text = "FISH: " + str(InventoryManager.get_fish_quantity())

func _on_retry_pressed() -> void:
	Global.descent(-1)

func _on_game_paused():
	hide()

func _on_game_unpaused():
	show()
