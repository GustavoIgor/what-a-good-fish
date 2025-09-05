extends CharacterBody2D

@onready var animation := $AnimationPlayer
@onready var sprite := $Sprite2D
var speed := 100
var game_paused := false

func _ready() -> void:
	Global.game_paused.connect(_on_game_paused)
	Global.game_unpaused.connect(_on_game_unpaused)

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
	else:
		animation.stop()

func _on_game_paused():
	game_paused = true

func _on_game_unpaused():
	game_paused = false
