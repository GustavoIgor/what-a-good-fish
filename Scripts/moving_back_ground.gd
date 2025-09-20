extends Node2D

@onready var static_bg: Sprite2D = $Back1
@onready var moving_bg: Sprite2D = $Back2

var move_speed: float = 100.0
var move_direction: Vector2 = Vector2.ZERO
var is_moving: bool = true

func _ready() -> void:
	randomize()
	_set_random_direction()
	_center_backgrounds()

func _process(delta: float) -> void:
	if not is_moving:
		return
	
	moving_bg.position += move_direction * move_speed * delta
	_check_bounds()

# --- lógica principal ---
func _set_random_direction() -> void:
	var angle = randf() * TAU # TAU = 2*PI
	move_direction = Vector2.RIGHT.rotated(angle).normalized()

func _check_bounds() -> void:
	var static_size = static_bg.texture.get_size()
	var moving_center = moving_bg.position
	var half_static = static_size / 2.0

	# limites considerando que o static_bg está centralizado
	if abs(moving_center.x) >= half_static.x or abs(moving_center.y) >= half_static.y:
		_set_random_direction()

func _center_backgrounds() -> void:
	static_bg.position = Vector2.ZERO
	moving_bg.position = Vector2.ZERO

# --- funções de controle ---
func stop_movement() -> void:
	is_moving = false

func start_movement() -> void:
	is_moving = true

func swap_backgrounds(new_static: Texture2D, new_moving: Texture2D) -> void:
	if new_static:
		static_bg.texture = new_static
	if new_moving:
		moving_bg.texture = new_moving
	_center_backgrounds()
	_set_random_direction()
