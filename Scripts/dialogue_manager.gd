extends CanvasLayer

signal dialogue_started
signal dialogue_ended
signal choice_made(choice_text)

var dialogue_data := []
var once_dialogues := []
var current_index := 0
var is_active := false
var is_typing := false
var skip_typing := false
var typing_speed := 0.03

@onready var name_label = $Panel/HBoxContainer/VBoxContainer/Name
@onready var text_label = $Panel/HBoxContainer/Message
@onready var icon = $Panel/HBoxContainer/VBoxContainer/Icon
@onready var background = $BackGround
@onready var background2 = $BackGround2
@onready var choices_box = $Choices

func start_dialogue(data: String):
	if is_active:
		return
	dialogue_data = DialogueCommunicator.get_dialogue(data)
	if dialogue_data.size() > 0 and dialogue_data[0].has("once") and dialogue_data[0]["once"] == "true":
		if data in once_dialogues:
			return
		else:
			once_dialogues.append(data)
	Global.pause_game()
	dialogue_started.emit()
	
	current_index = 0
	is_active = true
	show()
	show_next()

func show_next():
	choices_box.hide()
	_clear_choices()
	text_label.text = ""
	
	if current_index >= dialogue_data.size():
		end_dialogue()
		return

	var entry = dialogue_data[current_index]
	
	if entry.get("name", ""):
		name_label.text = entry.get("name", "")
	else:
		name_label.text = ""
	if entry.get("icon", ""):
		icon.texture = load("res://Assets/Arts/" + entry.get("icon", ""))
	else:
		icon.texture = null
	if entry.get("background", ""):
		background.texture = load(entry.get("background", ""))
	else:
		background.texture = null
	if entry.get("background2", ""):
		background2.texture = load(entry.get("background2", ""))
	else:
		background2.texture = null
	if entry.get("music", ""):
		SoundManager.play_music(entry.get("music", ""))
	if entry.get("sfx", ""):
		SoundManager.play_sfx(load(entry.get("sfx", "")), -20)
	
	var text = entry.get("text", "")
	await type_text(text)

	if entry.has("choices"):
		show_choices(entry["choices"])
	else:
		current_index += 1

func show_choices(choices: Array):
	choices_box.show()
	for choice_text in choices:
		var btn = Button.new()
		btn.text = choice_text
		btn.pressed.connect(_on_choice_pressed.bind(choice_text))
		choices_box.add_child(btn)

func _on_choice_pressed(choice_text):
	choice_made.emit(choice_text)
	current_index += 1
	show_next()

func end_dialogue():
	#Ui.show()
	Global.unpause_game()
	is_active = false
	hide()
	dialogue_ended.emit()

func _unhandled_input(event):
	if is_active and event.is_action_pressed("next_dialogue"):
		if is_typing:
			skip_typing = true
		elif choices_box.visible == false:
			show_next()

func _clear_choices():
	for child in choices_box.get_children():
		child.queue_free()

# Texto digitado
func type_text(text: String) -> void:
	is_typing = true
	skip_typing = false
	text_label.text = ""
	for i in text.length():
		if skip_typing:
			text_label.text = text
			break
		text_label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false
