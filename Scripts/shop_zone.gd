extends Node2D

func _ready() -> void:
	Global.is_descending = false
	if Global.level > 50:
		SoundManager.play_music(preload("res://Assets/music/Shopver_1.mp3"), false, -10)
	else:
		SoundManager.play_music(preload("res://Assets/music/Shopver_2.mp3"), false, -10)
