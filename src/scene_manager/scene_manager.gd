extends Node

var room_placeholder: PackedScene = preload("res://src/room_placeholder/room_placeholder.tscn")

var ground_obj: PackedScene = load("res://src/ground_object/ground_object.tscn")

var red_crystal = load("res://assets/misc/crystal_red.png")

var player: Node3D

var scene_data: Dictionary = {
	
}

var player_data: Dictionary = {
	"iih": "sword",
	"items": [],
	"lives": 3,
	"player_money": 10,
	"player_fossils": 100,
	"donated_fossils": 0
}

var dungeon := Dungeon.new(Vector2i(0, 0), 15)

func save_scene_with_data(id: String, data: Dictionary):
	scene_data[id] = data

func load_scene_with_data(id: String, scene: PackedScene):
	print(scene_data)
	print(player_data)
	get_tree().change_scene_to_packed(scene)
	if (scene.has_method("load_data")):
		scene.load_data(scene_data[id])

func set_player(node: Node3D):
	player = node

func get_player() -> Node3D:
	return player

func get_player_data():
	return player_data

func enter_dungeon():
	dungeon.generate_dungeon()
	var room_zero = dungeon.rooms[hash(Vector2i(0, 0))]
	var rm_node = Room3D.new(room_zero, [], Room3D.CrystalE.RED)
	
	get_tree().change_scene_to_packed(room_placeholder)
	get_tree().root.add_child(rm_node)
	
