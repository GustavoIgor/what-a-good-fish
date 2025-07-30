extends Node
signal game_paused
signal game_unpaused
signal changed

var change := false

func _ready() -> void:
	changed.connect(_on_changed)

func _on_changed():
	change = true

func no_change():
	change = false
