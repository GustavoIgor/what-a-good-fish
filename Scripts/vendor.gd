extends Node2D
@onready var label := $Label
@onready var shop_interface = $ShopInterface
var inside := false

func _on_shop_area_2d_body_entered(_body: Node2D) -> void:
	label.show()
	inside = true

func _on_shop_area_2d_body_exited(_body: Node2D) -> void:
	label.hide()
	inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shop") and inside:
		shop_interface.visible = !shop_interface.visible
