extends CharacterBody2D

@export var animation : AnimationPlayer
@export var camera : Camera2D
var speed := 100
var game_paused := false

func _ready() -> void:
	Global.game_paused.connect(_on_game_paused)
	Global.game_unpaused.connect(_on_game_unpaused)
	animation.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if game_paused:
		return
	var direction := Input.get_vector("left", "right","up", "down")
	
	velocity = direction * speed
	move_and_slide()
	animate()


func animate():
	if velocity != Vector2(0, 0):
		animation.play("walk")
		if Global.actual_scene == "shop" or Global.actual_scene == "intro":
			return
		RandomEncounter.register_time()
	else:
		animation.stop()

func _on_animation_finished():
	if animation.name == "walk":
		RandomEncounter.register_step()

func _on_game_paused():
	game_paused = true
	animation.stop()

func _on_game_unpaused():
	game_paused = false
