extends TextureRect

@export var slot_index := -1
@onready var icon := $Icon
@onready var quantity_label := $QuantityLabel
@onready var hover_panel := $HoverPanel
@onready var rich_text_label := $HoverPanel/ScrollContainer/VBoxContainer/RichTextLabel

var data: Dictionary = {}  # {"item": Item, "quantity": int}
var show_it := false

func _ready() -> void:
	refresh()

func set_data(new_data: Dictionary) -> void:
	data = new_data
	refresh()

func clear() -> void:
	data = {}
	refresh()

func refresh() -> void:
	if data:
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
			text += "[color=green]Consumable[/color]\n"
			text += "- Heal Amount: " + str(item.heal_amount) + "\n"
			text += "- Stamina Restore: " + str(item.stamina_restore) + "\n"

		if item is WeaponItem:
			text += "[color=red]Weapon[/color]\n"
			text += "- Damage: " + str(item.damage) + "\n"
			text += "- Attack Speed: " + str(item.attack_speed) + "\n"
			text += "- Durability: " + str(item.durability) + "\n"

		if item is ArmorItem:
			text += "[color=blue]Armor[/color]\n"
			text += "- Defense: " + str(item.defense) + "\n"
			text += "- Slot: " + str(item.slot) + "\n"

		rich_text_label.text = text
		
	else:
		modulate = Color(1,1,1,0.5)
		quantity_label.hide()
		icon.texture = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_it"):
		show_it = true
	if event.is_action_released("show_it"):
		show_it = false
	if Input.is_action_pressed("ui_down"):
		rich_text_label.get_v_scroll_bar().value += 10 # Adjust scroll speed as needed
	elif Input.is_action_pressed("ui_up"):
		rich_text_label.get_v_scroll_bar().value -= 10 # Adjust scroll speed as needed

func _on_mouse_entered() -> void:
	if data != null and show_it:
		hover_panel.visible = true

func _on_mouse_exited() -> void:
	hover_panel.visible = false
