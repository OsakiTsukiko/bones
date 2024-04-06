extends Node3D

var player_scene = load("res://src/player/player.tscn")
var player: Node3D

func _ready():
	if (player == null):
		player = player_scene.instantiate()
	add_child(player)
	SceneManager.set_player(player)
	player.position = Vector3(14, 1, 14)
