extends Node2D

@export var lake_scene: PackedScene
@export var chest_scene: PackedScene
@export var monster_scene: PackedScene
@export var stairs_scene: PackedScene
@export var player_packed: PackedScene

@export var wall_tile_id : Vector2i = Vector2i(0, 0)
@export var floor_tile_id : Vector2i = Vector2i(0, 1)

@onready var tilemap := $TileWrapper/Ground  # Assuming your TileMap is a child node

func _ready():
	Global.is_descending = false
	generate_room()
	place_objects()
	place_player()
	InventoryManager.add_item(ItemGenerator.small_potion, 1)
	SoundManager.play_music(load("res://Assets/music/WHAT A GOOD FISH.wav"), false, -10)

func generate_room():
	# Set all tiles to floor first
	for x in range(20):
		for y in range(20):
			tilemap.set_cell(Vector2i(x, y), 0, floor_tile_id)
	
	# Add random walls (about 20% of tiles)
	for x in range(20):
		for y in range(20):
			if randf() < 0.2:  # 20% chance for a wall
				tilemap.set_cell(Vector2i(x, y), 0, wall_tile_id)
	
	# Ensure borders are walls for a contained room
	for x in range(20):
		tilemap.set_cell(Vector2i(x, 0), 0, wall_tile_id)
		tilemap.set_cell(Vector2i(x, 19), 0, wall_tile_id)
	for y in range(20):
		tilemap.set_cell(Vector2i(0, y), 0, wall_tile_id)
		tilemap.set_cell(Vector2i(19, y), 0, wall_tile_id)

func place_objects():
	# Place lakes (2-3)
	var lake_count = randi_range(2, 3)
	place_random_objects(lake_scene, lake_count, true)
	
	# Place chests (0-3)
	var chest_count = randi_range(0, 3)
	place_random_objects(chest_scene, chest_count)
	
	# Place monsters (0-5)
	var monster_count = randi_range(0, 5)
	place_random_objects(monster_scene, monster_count)
	
	# Place stairs (1-2)
	var stairs_count = randi_range(1, 2)
	place_random_objects(stairs_scene, stairs_count)

func place_random_objects(scene: PackedScene, count: int, is_lake: bool = false):
	for i in range(count):
		var attempts = 0
		var valid_position = false
		var tile_position
		
		# Try to find a valid position (not on wall or other objects)
		while not valid_position and attempts < 100:
			tile_position = Vector2(randi_range(1, 18), randi_range(1, 18))
			# For lakes, we can place them anywhere except walls
			if is_lake and tilemap.get_cell_atlas_coords(tile_position) != wall_tile_id:
				valid_position = true
			# For other objects, only place on floor tiles
			elif tilemap.get_cell_atlas_coords(tile_position) == floor_tile_id:
				valid_position = true
			
			# Additional check to avoid overlapping with existing objects
			if valid_position:
				for child in get_children():
					if child is StaticBody2D:
						if child.position.distance_to(tile_position) < 16:  # Rough proximity check
							valid_position = false
							break
			
			attempts += 1
		
		if valid_position:
			print("placed")
			var instance = scene.instantiate()
			instance.position = tilemap.map_to_local(tile_position)
			add_child(instance)

func place_player():
	var player = player_packed.instantiate()
	add_child(player)
	var attempts = 0
	var placed = false
	
	while not placed and attempts < 100:
		var spawn_position = Vector2(randi_range(1, 18), randi_range(1, 18))
		var tile_pos = tilemap.local_to_map(position)
		
		# Check if tile is floor (not wall or lake)
		if tilemap.get_cell_atlas_coords(tile_pos) == floor_tile_id:
			# Additional check to make sure it's not on other objects
			var overlapping = false
			for child in get_children():
				if child != player and child is Node2D:
					if child.position.distance_to(spawn_position) < 16:  # Rough proximity check
						overlapping = true
						break
			
			if not overlapping:
				player.position = spawn_position
				placed = true
		
		attempts += 1
	
	if not placed:
		# Fallback - find first available floor tile
		for x in range(20):
			for y in range(20):
				if tilemap.get_cell_atlas_coords(Vector2i(x, y)) == floor_tile_id:
					var pos = tilemap.map_to_local(Vector2i(x, y))
				# Double check for overlapping objects
					var clear = true
					for child in get_children():
						if child != player and child is Node2D:
							if child.position.distance_to(pos) < 16:
								clear = false
								break
					if clear:
						player.position = pos
						return
