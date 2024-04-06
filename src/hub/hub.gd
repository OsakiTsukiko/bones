extends Node3D

# Called when the node enters the scene tree for the first time.
var test_scene: PackedScene = load("res://src/test/test.tscn")
var player_scene: PackedScene = load("res://src/player/player.tscn")
var player: Node3D = null

@onready var fossil1 = load("res://assets/fossil/fossil1.png")
@onready var fossil2 = load("res://assets/fossil/fossil2.png")
@onready var fossil3 = load("res://assets/fossil/fossil3.png")
@onready var fossil4 = load("res://assets/fossil/fossil4.png")
@onready var fossil5 = load("res://assets/fossil/fossil5.png")
@onready var fossil6 = load("res://assets/fossil/fossil6.png")

func load_data(data: Dictionary):
	player = player_scene.instantiate()
	player.load_data(SceneManager.get_player_data())

func setup_room():
	var room: Room = Room.new(Vector2i(0, 0), false);
	var room_3d: Room3D = Room3D.new(room, [])
	add_child(room_3d);
	

# Called when the node enters the scene tree for the first time.
func _ready():
	load_fossil()
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
	# SceneManager.enter_dungeon()
	SceneManager.pre_enter_dungeon()

func _on_item_body_entered(body, item: String):
	if body.has_method("is_player"):
		if !SceneManager.player_data["items"].has(item):
			# buy item
			if (item == "heart" && SceneManager.player_data["player_money"] >= 5):
				SceneManager.player_data["player_money"] -= 5;
				SceneManager.player_data["items"].append(item)
			if (item == "speed" && SceneManager.player_data["player_money"] >= 4):
				SceneManager.player_data["player_money"] -= 4;
				SceneManager.player_data["items"].append(item)
			if (item == "time" && SceneManager.player_data["player_money"] >= 7):
				SceneManager.player_data["player_money"] -= 7;
				SceneManager.player_data["items"].append(item)
			
			$Player.load_data(SceneManager.player_data)

func _change_scene_to(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)

func load_fossil():
	if SceneManager.player_data["donated_fossils"] >= 0 && SceneManager.player_data["donated_fossils"] < 10:
		$Fossil/Sprite3D.texture = fossil1
	if SceneManager.player_data["donated_fossils"] >= 10 && SceneManager.player_data["donated_fossils"] < 20:
		$Fossil/Sprite3D.texture = fossil2
	if SceneManager.player_data["donated_fossils"] >= 20 && SceneManager.player_data["donated_fossils"] < 30:
		$Fossil/Sprite3D.texture = fossil3
	if SceneManager.player_data["donated_fossils"] >= 30 && SceneManager.player_data["donated_fossils"] < 40:
		$Fossil/Sprite3D.texture = fossil4
	if SceneManager.player_data["donated_fossils"] >= 40 && SceneManager.player_data["donated_fossils"] < 50:
		$Fossil/Sprite3D.texture = fossil5
	if SceneManager.player_data["donated_fossils"] >= 50:
		$Fossil/Sprite3D.texture = fossil6

func _on_fossil_entered(body):
	if body.has_method("is_player"):
		SceneManager.player_data["donated_fossils"] += SceneManager.player_data["player_fossils"];
		SceneManager.player_data["player_fossils"] = 0
		$Player.load_data(SceneManager.player_data)
		load_fossil()
		
		
