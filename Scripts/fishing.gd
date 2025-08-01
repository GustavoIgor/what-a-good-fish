extends CanvasLayer

@onready var bar = $Panel/GrayBar
@onready var green_zone = $Panel/GrayBar/GreenBar
@onready var pointer = $Panel/GrayBar/Pointer
@onready var timer = $PointerTimer

@export var pointer_speed := 300.0  # px per second

var pointer_dir := 1  # 1 = right, -1 = left
var success_zone = Rect2()  # Green area

func _ready():
	randomize_fishing_zone()
	Global.pause_game()
	timer.start()

func _process(delta):
	pointer.position.x += pointer_speed * delta * pointer_dir
	var bar_width = bar.size.x

	# Invert the limits direction
	if pointer.position.x < 0:
		pointer.position.x = 0
		pointer_dir = 1
	elif pointer.position.x > bar_width:
		pointer.position.x = bar_width
		pointer_dir = -1

func _input(event):
	if event.is_action_pressed("ui_accept"):
		check_result()

func check_result():
	var pointer_x = pointer.position.x
	Global.unpause_game()
	Global.change_stamina(-33)
	if pointer_x >= success_zone.position.x and pointer_x <= success_zone.position.x + success_zone.size.x:
		Global.fish_caught.emit(true)
	else:
		Global.fish_caught.emit(false)
	queue_free()

func randomize_fishing_zone():
	var bar_width = bar.size.x
	var zone_width = 60 + randi_range(0, 40)  # Green area lenght

	var start_x = randi_range(0, int(bar_width - zone_width))
	success_zone = Rect2(start_x, 0, zone_width, bar.size.y)

	green_zone.position.x = success_zone.position.x
	green_zone.size.x = success_zone.size.x
