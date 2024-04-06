extends Node3D

# Called when the node enters the scene tree for the first time.
var test_scene: PackedScene = load("res://src/test/test.tscn")
var player_scene: PackedScene = load("res://src/player/player.tscn")
var player: Node3D = null

func load_data(data: Dictionary):
	player = player_scene.instantiate()
	player.load_data(SceneManager.get_player_data())

func setup_room():
	var room: Room = Room.new(Vector2i(0, 0), false);
	var room_3d: Room3D = Room3D.new(room, [])
	add_child(room_3d);

# Called when the node enters the scene tree for the first time.
func _ready():
	if (player == null):
		player = player_scene.instantiate()
	setup_room()
	add_child(player)
	player.position = Vector3(12, 1, 12)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_portal_body_entered(body):
	if body == $Player:
		call_deferred("ed_wrapper")


func ed_wrapper():
	SceneManager.enter_dungeon()

func _on_item_body_entered(body, item: String):
	if body.has_method("is_player"):
		if !SceneManager.player_data["items"].has(item):
			SceneManager.player_data["items"].append(item)
			$Player.load_data(SceneManager.player_data)

func _change_scene_to(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)


func _on_item_bodys_entered(body_rid, body, body_shape_index, local_shape_index, extra_arg_0):
	pass # Replace with function body.
