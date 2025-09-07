extends Node2D

var names := ["Tuna", "Salmon", "Cod", "Mackerel", "Sardine", "Catfish",
 "Bass", "Trout", "Flounder", "Halibut", "Goldfish"]
var rarity := 0
var this_name := "Name"
var weight := 2.3

func _ready() -> void:
	this_name = names.pick_random()
	rarity = randi_range(0, 5)
	weight = randf_range(0.0, 10.0)
	self.modulate = Color(randf_range(0, 1), 1, 1, 1)
