extends Node
signal game_paused
signal game_unpaused
signal changed
signal money_changed
signal stamina_changed
signal hp_changed
signal fish_caught(caught : bool)

var change := false
var money := 0.0
var level := 1
var fishing := false
var is_descending := false
var is_in_battle := false
var is_game_paused := false
var actual_scene : String

var player_stats :={
	"stamina" : 100,
	"max_stamina" : 100,
	"hp" : 100,
	"max_hp" : 100
}

var events : Dictionary = {
	"vendor_first_interaction" : false
}

func _ready() -> void:
	changed.connect(_on_changed)
	fish_caught.connect(_on_fish_caught)

func _on_changed():
	change = true

func no_change():
	change = false

func change_money(amount : float):
	money = clamp(money + amount, 0, 100000)
	money_changed.emit()

func change_hp(amount : int):
	player_stats["hp"] = clamp(player_stats["hp"] + amount, 0, player_stats["max_hp"])
	hp_changed.emit()
	if player_stats["hp"] == 0:
		game_over()

func change_stamina(amount : int):
	player_stats["stamina"] = clamp(player_stats["stamina"] + amount, 0, player_stats["max_stamina"])
	stamina_changed.emit()

func descent(amount : int):
	BattleManager.hide()
	level += amount
	
	if level <= 0:
		level = 0
		Fade.fade_transition("") # Put Cave entrance here
		return
	
	if amount == 0:
		Fade.fade_transition("res://Scenes/dungeon.tscn")
		return
	
	if money >= 10000:
		win()
		return
	
	player_stats["stamina"] = player_stats["max_stamina"]
	if level % 10 == 0:
		Fade.fade_transition("res://Scenes/dungeon.tscn")
	elif level % 5 == 0:
		Fade.fade_transition("res://Scenes/shop_zone.tscn")
	else:
		Fade.fade_transition("res://Scenes/dungeon.tscn")

func _on_fish_caught(caught : bool):
	if caught:
		DialogueManager.start_dialogue("fish_caught")
	else:
		DialogueManager.start_dialogue("fish_caught_failed")

func player_attack():
	return 10

func win():
	Fade.fade_transition("res://Scenes/win.tscn")

func game_over():
	pass

func pause_game():
	game_paused.emit()
	is_game_paused = true

func unpause_game():
	if is_descending or is_in_battle or DialogueManager.is_active:
		return
	game_unpaused.emit()
	is_game_paused = false
