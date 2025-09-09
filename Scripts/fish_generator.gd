extends Node

#This node generates 

func generate_random_fish() -> FishData:
	var data := FishData.new()

	# Random name
	var names := ["Tuna", "Salmon", "Cod", "Mackerel", "Sardine",
		"Catfish", "Bass", "Trout", "Flounder", "Halibut", "Goldfish"]
	data.name = names[randi() % names.size()]

	# Rarity between 0 and 5
	data.rarity = randi_range(1, 5)

	# weight between 1 and 10
	data.weight = randf_range(0.1, 10.0)

	#Texture 
	# TODO: more fish icons 
	data.icon = preload("res://Assets/Arts/tuna.png")

	return data
