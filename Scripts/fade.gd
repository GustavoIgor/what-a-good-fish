extends CanvasLayer

@onready var animation := $AnimationPlayer
var _next_scene_path := ""

func fade_transition(path : String):
	Global.game_paused.emit()
	_next_scene_path = path
	show()
	animation.play("fade_in")

func _on_animation_finished(anim_name: String):
	if anim_name == "fade_in" and _next_scene_path != "":
		get_tree().change_scene_to_file(_next_scene_path)
		animation.play("fade_out")
	elif anim_name == "fade_out":
		Global.game_unpaused.emit()
		hide()
		_next_scene_path = ""

func _ready():
	animation.animation_finished.connect(_on_animation_finished)
