extends Panel
class_name InventorySlot

signal delete

@onready var icon := $Icon
@onready var hover_panel := $HoverPanel
@onready var name_label := $HoverPanel/VBoxContainer/NameLabel
@onready var rarity_label := $HoverPanel/VBoxContainer/RarityLabel
@onready var weight_label := $HoverPanel/VBoxContainer/WeightLabel
@onready var util_panel := $UtilPanel

var data: FishData = null
var show_it := false

func _ready() -> void:
	refresh()
	hover_panel.set_anchors_preset(Control.PRESET_FULL_RECT)

func set_data(new_data: FishData) -> void:
	data = new_data
	refresh()

func clear() -> void:
	data = null
	refresh()

func refresh() -> void:
	if data:
		modulate = Color(1,1,1,1)
		icon.texture = data.icon
		name_label.text = data.name
		rarity_label.text = "Rarity: " + str(data.rarity)
		weight_label.text = "Weight: " + str("%.2f" % data.weight) 
	else:
		modulate = Color(1,1,1,0.5)
		icon.texture = null
		name_label.text = ""
		rarity_label.text = ""
		weight_label.text = ""

# Only shows if control is pressed
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_it"):
		show_it = true
	if event.is_action_released("show_it"):
		show_it = false

#Function for mouse hover
func _on_mouse_entered() -> void:
	if data != null and show_it:
		hover_panel.visible = true

func _on_mouse_exited() -> void:
	hover_panel.visible = false
	hide_util_panel()

func show_util_panel():
	util_panel.visible = true

func hide_util_panel():
	util_panel.visible = false

func _on_delete_pressed() -> void:
	delete.emit()
	hide_util_panel()
