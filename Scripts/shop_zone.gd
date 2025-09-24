extends Node2D

func _ready() -> void:
	Global.actual_scene = "shop"
	Global.is_descending = false
	SoundManager.check_music()
