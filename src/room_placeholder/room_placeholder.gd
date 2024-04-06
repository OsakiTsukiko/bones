extends Node3D

var player_scene = load("res://src/player/player.tscn")
var player: Node3D
var r3d: Room3D

func _ready():
	if (player == null):
		player = player_scene.instantiate()
	add_child(player)
	SceneManager.set_player(player)
	player.position = Vector3(14, 1, 14)

func post_init(p_r3d: Room3D, player_rotation: Vector3):
	r3d = p_r3d
	if r3d.ppos != Vector3(-1, -1, -1):
		player.position = r3d.ppos
		player.position.y = 1
		player.rotation = player_rotation
	else:
		match r3d.from:
			"N":
				player.position = r3d.dv[0]
				player.position.y = 1
				player.position.x = 2
			"S":
				player.position = r3d.dv[1]
				player.position.y = 1
				player.position.x = Room.ROOM_SIZE - 3
			"W":
				player.position = r3d.dv[2]
				player.position.y = 1
				player.position.z = 1
			"E":
				player.position = r3d.dv[3]
				player.position.y = 1
				player.position.z = Room.ROOM_SIZE - 2
	
	match r3d.from:
		"N":
			pass 
		"S":
			pass 
		"W":
			pass 
		"E":
			pass 
