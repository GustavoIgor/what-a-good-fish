extends Node

var dialogue_path := "res://JSONS/"
var dialogue_name := ""
var cache = {}

func get_dialogue(d_name: String) -> Array:
	dialogue_name = d_name
	if cache.has(d_name):
		return cache[d_name]

	var file_path = dialogue_path + d_name + ".json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Dialogue '%s' not found." % d_name)
		return []

	var json_string = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_string)
	if result is Array:
		cache[d_name] = result
		return result
	else:
		push_error("Error in loading JSON '%s'." % d_name)
		return []
