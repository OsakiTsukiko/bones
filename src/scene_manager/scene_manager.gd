extends Node

var room_placeholder: PackedScene = preload("res://src/room_placeholder/room_placeholder.tscn")
var rnode_scene: PackedScene = preload("res://r_node.tscn")

var ground_obj: PackedScene = load("res://src/ground_object/ground_object.tscn")

var red_crystal = load("res://assets/misc/crystal_red.png")

var player: Node3D

var parent_node: Node3D

var cadaver_scene: PackedScene = load("res://src/ground_object/cadaver.tscn")

var scene_data: Dictionary = {
	
}

var player_looking_direction: Vector3;

var player_data: Dictionary = {
	"iih": "sword",
	"items": [],
	"lives": 3,
	"player_money": 10,
	"player_fossils": 100,
	"donated_fossils": 0
}

var dungeon := Dungeon.new(Vector2i(0, 0), 2)
var is_dungeon_future := false

func save_scene_with_data(id: String, data: Dictionary):
	scene_data[id] = data

func load_scene_with_data(id: String, scene: PackedScene):
	print(scene_data)
	print(player_data)
	get_tree().change_scene_to_packed(scene)
	if (scene_data.has(scene_data)):
		if (scene.has_method("load_data")):
			scene.load_data(scene_data[id])

func set_player(node: Node3D):
	player = node

func get_player() -> Node3D:
	return player

func get_player_data():
	return player_data

func pre_enter_dungeon():
	get_tree().change_scene_to_packed(rnode_scene)

func rn_init(n: Node3D):
	parent_node = n
	enter_dungeon()

func enter_dungeon():
	dungeon.generate_dungeon()
	var room_zero = dungeon.rooms[hash(Vector2i(0, 0))]
	var rm_node = Room3D.new(room_zero, [], Room3D.CrystalE.RED)
	
	for child in parent_node.get_children():
		child.queue_free()
	var rmplh = room_placeholder.instantiate()
	parent_node.add_child(rmplh)
	rmplh.add_child(rm_node)

func enter_room(coords: Vector2i, from: String, darr: Array[String] = [], player_rotation: Vector3 = Vector3.ZERO):
	var new_room: Room = dungeon.rooms[hash(coords)]
	var new_crystal := Room3D.CrystalE.RED
	if (scene_data.has(str(hash(coords)))):
		print(scene_data.has(str(hash(coords))))
		darr = scene_data[str(hash(coords))]["doors"]
		print(darr)
		new_crystal = Room3D.CrystalE.GRAY
	if is_dungeon_future:
		new_crystal = Room3D.CrystalE.GRAY
	var rrm_node = Room3D.new(new_room, darr, new_crystal)
	rrm_node.from = from 
	for child in parent_node.get_children():
		child.queue_free()
	var rmplh = room_placeholder.instantiate()
	parent_node.add_child(rmplh)
	rmplh.add_child(rrm_node)
	
	if (scene_data.has(str(hash(coords)))):
		for cadaver in scene_data[str(hash(coords))]["cadavers"]:
			var ncadaver: Area3D = cadaver_scene.instantiate()
			rrm_node.cadavers.append(ncadaver)
			rrm_node.add_child(ncadaver)
			ncadaver.position = cadaver
			if is_dungeon_future:
				ncadaver.body_entered.connect(cadaver_collected)
	
	rmplh.post_init(rrm_node, player_rotation)

func cadaver_collected(body):
	if body.has_method("is_player"):
		player_data["player_fossils"] += 1
		player.load_data(player_data)
		print(player_data["player_fossils"])

func change_to_future(body):
	if body.has_method("is_player"):
		is_dungeon_future = true
		print("WELCOME TO THE FUTURE")
	
