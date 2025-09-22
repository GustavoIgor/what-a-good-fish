extends TextureRect

signal delete
signal use
signal equip

@export var slot_index := -1
@onready var icon := $Icon
@onready var quantity_label := $QuantityLabel
@onready var hover_panel := $HoverPanel
@onready var util_panel := $UtilPanel
@onready var rich_text_label := $HoverPanel/ScrollContainer/VBoxContainer/RichTextLabel

var data: Dictionary = {}  # {"item": Item, "quantity": int}
var show_it := false

func _ready() -> void:
	refresh()

func set_data(new_data: Dictionary) -> void:
	data = new_data
	refresh()

func set_data_singular(new_data : Item) -> void:
	data = {"item" : new_data, "quantity" : 1}
	refresh()

func clear() -> void:
	data = {}
	refresh()

func refresh() -> void:
	$UtilPanel/VBoxContainer/Use.hide()
	$UtilPanel/VBoxContainer/Equip.hide()
	$UtilPanel/VBoxContainer/Delete.hide()
	if data:
		$UtilPanel/VBoxContainer/Delete.show()
		modulate = Color(1,1,1,1)
		icon.texture = data["item"].icon
		var item: Item = data["item"]
		icon.texture = item.icon
		quantity_label.show()
		quantity_label.text = str(data["quantity"]) if item.stackable else ""
	
		# Update hover information
		var text := ""

	# Nome sempre em destaque
		text += "[b]" + item.name + "[/b]\n"
		text += item.description + "\n\n"

		if item is ConsumableItem:
			$UtilPanel/VBoxContainer/Use.show()
			text += "[color=green]Consumable[/color]\n"
			text += "- Heal Amount: " + str(item.heal_amount) + "\n"
			text += "- Stamina Restore: " + str(item.stamina_restore) + "\n"

		if item is WeaponItem:
			$UtilPanel/VBoxContainer/Equip.show()
			text += "[color=red]Weapon[/color]\n"
			text += "- Damage: " + str(item.damage) + "\n"
			text += "- Attack Speed: " + str(item.attack_speed) + "\n"
			text += "- Durability: " + str(item.durability) + "\n"

		if item is ArmorItem:
			$UtilPanel/VBoxContainer/Equip.show()
			text += "[color=blue]Armor[/color]\n"
			text += "- Defense: " + str(item.defense) + "\n"
			text += "- Slot: " + str(item.slot) + "\n"

		rich_text_label.text = text
		
	else:
		modulate = Color(1,1,1,0.5)
		quantity_label.hide()
		icon.texture = null
		rich_text_label.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_it"):
		show_it = true
	if event.is_action_released("show_it"):
		show_it = false
	if Input.is_action_pressed("ui_down"):
		rich_text_label.get_v_scroll_bar().value += 10 # Adjust scroll speed as needed
	elif Input.is_action_pressed("ui_up"):
		rich_text_label.get_v_scroll_bar().value -= 10 # Adjust scroll speed as needed

func hide_util_panel():
	util_panel.visible = false

func show_util_panel():
	util_panel.visible = true

func _on_mouse_entered() -> void:
	if data != null and show_it:
		hover_panel.visible = true

func _on_mouse_exited() -> void:
	hover_panel.visible = false
	hide_util_panel()

func _on_delete_pressed() -> void:
	delete.emit()
	hide_util_panel()

func _on_use_pressed() -> void:
	use.emit()
	hide_util_panel()

func _on_equip_pressed() -> void:
	equip.emit()
	hide_util_panel()
