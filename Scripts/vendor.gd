extends Node2D
@onready var label := $Label
@onready var trade_interface = $TradeInterface
var inside := false

func _on_shop_area_2d_body_entered(_body: Node2D) -> void:
	label.show()
	inside = true

func _on_shop_area_2d_body_exited(_body: Node2D) -> void:
	label.hide()
	inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shop") and inside:
		if Global.events["vendor_first_interaction"] == false:
			DialogueManager.start_dialogue("vendor_first_interaction")
		else:
			trade_interface.visible = !trade_interface.visible
	if event.is_action_pressed("cancel"):
		trade_interface.visible = false
