extends Node
var cards: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_paths = get_all_file_paths("res://resources/cards/")
	for card_path in card_paths:  
		if '.tres.remap' in card_path: # <---- NEW
			card_path = card_path.trim_suffix('.remap') # <---- NEW
		var card = ResourceLoader.load(card_path)
		cards.append(card)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_all_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_all_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths
