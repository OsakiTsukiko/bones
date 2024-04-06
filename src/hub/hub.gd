extends Node3D

# Called when the node enters the scene tree for the first time.
var test_scene: PackedScene = load("res://src/test/test.tscn")
var player_scene: PackedScene = load("res://src/player/player.tscn")
var player: Node3D = null

func load_data(data: Dictionary):
	player = player_scene.instantiate()
	player.load_data(SceneManager.get_player_data())

func setup_room():
	var room_3d: Room3D = Room3D.new(room)
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
	print(1, body)
	if body == $Player:
		call_deferred("_change_scene_to", test_scene)

func _change_scene_to(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
