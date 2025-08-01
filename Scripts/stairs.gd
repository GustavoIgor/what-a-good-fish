extends StaticBody2D

var inside := false

func _input(event):
	if event.is_action_pressed("ui_accept") and inside:
		Global.descent(1)

func _on_interaction_area_2d_body_entered(body: Node2D) -> void:
	inside = true
	$Label.show()

func _on_interaction_area_2d_body_exited(body: Node2D) -> void:
	inside = false
	$Label.hide()
