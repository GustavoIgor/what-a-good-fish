extends Node
@onready var music := $Music
@onready var sfx := $SFX
@onready var sfx2 := $SFX2

var current_music : AudioStream = null

func play_sfx(sound: AudioStream, volume: int = 0):
	if !sfx.playing:
		sfx.volume_db = volume
		sfx.stream = sound
		sfx.play()
	elif !sfx2.playing:
		sfx2.volume_db = volume
		sfx2.stream = sound
		sfx2.play()
	else:
		# Ambos estão ocupados, opcional: ignorar ou parar um deles
		sfx.stop()
		sfx.stream = sound
		sfx.play()

func check_music():
	match Global.actual_scene:
		"dungeon":
			play_music(load("res://Assets/music/WHAT A GOOD FISH.wav"), false, -10)
		"shop":
			if Global.level > 50:
				play_music(preload("res://Assets/music/Shopver_1.mp3"), false, -10)
			else:
				play_music(preload("res://Assets/music/Shopver_2.mp3"), false, -10)

func play_music(music_stream, force_restart := false, volume : int = 0):
	if music_stream is String:
		music_stream = load(music_stream)
	
	if current_music == music_stream and !force_restart:
		return
	
	current_music = music_stream
	music.stop()
	music.volume_db = volume
	music.stream = music_stream
	music.play()

func stop_music():
	music.stop()
	current_music = null

func stop_all_sfx():
	sfx.stop()
	sfx2.stop()
