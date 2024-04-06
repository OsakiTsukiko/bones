extends Node

var scene_data: Dictionary = {
	
}

var player_data: Dictionary = {
	
}

func save_scene_with_data(id: String, data: Dictionary):
	scene_data[id] = data

func load_scene_with_data(id: String, scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
	if (scene.has_method("load_data")):
		scene.load_data(scene)

func get_player_data():
	return player_data
