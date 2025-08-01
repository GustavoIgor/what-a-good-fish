extends StaticBody2D

@onready var animation := $AnimationPlayer
@onready var sprite := $Sprite2D
var inside := false
var reward : int = 100 * Global.level

func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finished)

func open():
	SoundManager.play_sfx(load("res://Assets/SFX/cabinet-open-44955.mp3"))
	animation.play("Open")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Open":
		Global.change_money(reward)
		queue_free()

func _input(event):
	if event.is_action_pressed("ui_accept") and inside:
		open()

func _on_area_2d_body_entered(body: Node2D) -> void:
	inside = true
	$Label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	inside = false
	$Label.hide()
