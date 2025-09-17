extends Node

func _ready() -> void:
	DialogueManager.choice_made.connect(_on_choice_made)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
func _on_choice_made(choice : String):
	match choice:
		_:
			pass

func _on_dialogue_ended():
	match DialogueCommunicator.dialogue_name:
		"vendor_first_interaction":
			Global.events["vendor_first_interaction"] = true
		"fish_caught":
			Global.fishing = false
		"fish_caught_failed":
			Global.fishing = false
