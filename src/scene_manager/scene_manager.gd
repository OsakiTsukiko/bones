extends Node

var scene_data: Dictionary = {
	
}

var player_data: Dictionary = {
	"iih": "sword",
	"items": [],
	"lives": 3,
	"player_money": 0
}

func save_scene_with_data(id: String, data: Dictionary):
	scene_data[id] = data

func load_scene_with_data(id: String, scene: PackedScene):
	print(scene_data)
	print(player_data)
	get_tree().change_scene_to_packed(scene)
	if (scene.has_method("load_data")):
		scene.load_data(scene_data[id])

func get_player_data():
	return player_data
