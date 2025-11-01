extends Area2D

@export var teleport_to : String
@export var active : bool

func _on_body_entered(_body: Node2D) -> void:
	if active:
		Fade.fade_transition("res://Scenes/" + teleport_to + ".tscn")
