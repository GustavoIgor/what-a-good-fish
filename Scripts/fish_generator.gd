extends Node

#This node generates 

func generate_random_fish() -> FishData:
	var data := FishData.new()

	# Random name (freshwater fish)
	var names := [
		"Catfish", "Bass", "Trout", "Pike", "Perch", "Bluegill", "Crappie", 
		"Carp", "Walleye", "Muskellunge", "Sturgeon", "Gar", "Sunfish", 
		"Shad", "Minnow", "Bullhead", "Burbot", "Dace", "Chub", "Roach"
	]
	data.name = names[randi() % names.size()]

	# Rarity (1 - common, 5 - ultra-rare)
	var rarity_roll := randf()
	if rarity_roll < 0.5:
		data.rarity = 1  # Common (50%)
	elif rarity_roll < 0.8:
		data.rarity = 2  # Uncommon (30%)
	elif rarity_roll < 0.95:
		data.rarity = 3  # Rare (15%)
	elif rarity_roll < 0.99:
		data.rarity = 4  # Very Rare (4%)
	else:
		data.rarity = 5  # Ultra-Rare (1%)

	# Weight (adjusted based on fish type)
	match data.name:
		"Catfish", "Carp", "Sturgeon", "Muskellunge", "Pike":
			data.weight = randf_range(5.0, 50.0)  # Larger fish
		"Bass", "Trout", "Walleye", "Gar":
			data.weight = randf_range(2.0, 10.0)  # Medium fish
		"Perch", "Bluegill", "Crappie", "Sunfish", "Bullhead":
			data.weight = randf_range(0.5, 2.0)  # Small fish
		"Shad", "Minnow", "Dace", "Chub", "Roach":
			data.weight = randf_range(0.1, 0.5)  # Very small fish
		_:
			data.weight = randf_range(0.1, 10.0)  # Default range

	# Texture (placeholder for now)
	# TODO: Add more fish icons
	data.icon = preload("res://Assets/Arts/tuna.png")

	return data
