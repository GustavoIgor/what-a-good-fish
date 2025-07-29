extends Node

var dialogue_path := "res://JSONS/"
var dialogue_name := ""
var cache = {}

func get_dialogue(name: String) -> Array:
	dialogue_name = name
	if cache.has(name):
		return cache[name]

	var file_path = dialogue_path + name + ".json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Dialogue '%s' not found." % name)
		return []

	var json_string = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_string)
	if result is Array:
		cache[name] = result
		return result
	else:
		push_error("Error in loading JSON '%s'." % name)
		return []
