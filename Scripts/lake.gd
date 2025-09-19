extends StaticBody2D

@onready var label := $Label
var inside := false

func _input(event):
	if event.is_action_pressed("fishing") and inside:
		if Global.fishing:
			return
		if Global.player_stats["stamina"] < 33:
			label.text = "You have no stamina to fish now"
		elif InventoryManager.get_fish_quantity() >= InventoryManager.fish_capacity:
			label.text = "Your inventory is full"
		else:
			SoundManager.play_sfx(load("res://Assets/SFX/water-splash-02-352021.mp3"), -20)
			var fishing = preload("res://Scenes/fishing.tscn").instantiate()
			get_tree().current_scene.add_child(fishing)
			Global.fishing = true

func _on_interaction_area_2d_body_entered(_body: Node2D) -> void:
	inside = true
	label.show()

func _on_interaction_area_2d_body_exited(_body: Node2D) -> void:
	inside = false
	label.hide()
