extends Node

var dialogue_path := "res://Resources/Dialogues/"
var dialogue_name := ""
var cache = {}
var once_dialogues: Array[String] = []

func get_dialogue(d_name: String) -> Array[DialogueEntry]:
	dialogue_name = d_name
	if cache.has(d_name):
		var cached_resource: DialogueResource = cache[d_name]
		# Check if it's a "once" dialogue and already viewed
		if cached_resource.once and d_name in once_dialogues:
			return []
		if cached_resource.once:
			once_dialogues.append(d_name)
		return cached_resource.entries

	var file_path = dialogue_path + d_name + ".tres"
	var resource = ResourceLoader.load(file_path) as DialogueResource
	if not resource:
		push_error("Dialogue '%s' not found." % d_name)
		return []

	cache[d_name] = resource
	
	# Check if it's a "once" dialogue
	if resource.once:
		if d_name in once_dialogues:
			return []
		once_dialogues.append(d_name)
	
	return resource.entries
