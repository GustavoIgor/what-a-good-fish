extends Node
signal game_paused
signal game_unpaused
signal changed
signal money_changed
signal stamina_changed
signal fish_caught(caught : bool)

var change := false
var money := 0.0
var stamina := 100
var max_stamina := 100
var level := 4
var fishing := false

func _ready() -> void:
	changed.connect(_on_changed)
	fish_caught.connect(_on_fish_caught)

func _on_changed():
	change = true

func no_change():
	change = false

func change_money(amount : float):
	money = clamp(money + amount, 0, 100000)
	print(money)
	money_changed.emit()

func change_stamina(amount : int):
	stamina = clamp(stamina + amount, 0, max_stamina)
	stamina_changed.emit()

func descent(amount : int):
	if amount == 0:
		Fade.fade_transition("res://Scenes/dungeon.tscn")
		return
	level += amount
	
	if money >= 10000:
		win()
		return
	
	stamina = max_stamina
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

func win():
	Fade.fade_transition("res://Scenes/win.tscn")

func pause_game():
	game_paused.emit()

func unpause_game():
	game_unpaused.emit()
