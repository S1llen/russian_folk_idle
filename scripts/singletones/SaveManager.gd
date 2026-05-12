extends Node


@onready var game_node = $/root/Game


func _ready() -> void:
	load_from_file()


func _exit_tree() -> void:
	save_to_file()


func save_to_file():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var game_data = game_node.call("save_game")
	
	var json_string = JSON.stringify(game_data)
	
	save_file.store_line(json_string)
	print("Game data saved")


func load_from_file():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	var json_string = save_file.get_line()
	
	# Helper class
	var json = JSON.new()
	
	# Check parsing error
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
	var load_data = json.data
	game_node.load_game(load_data)
	print("Game data loaded")
