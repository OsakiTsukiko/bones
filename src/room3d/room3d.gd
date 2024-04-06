extends Node3D
class_name Room3D

var room: Room
var room_block_scene: PackedScene = load("res://src/room3d/room_block.tscn")
var room_barrier_scene: PackedScene = load("res://src/room3d/room_barrier.tscn")
var room_bridge_scene: PackedScene = load("res://src/room3d/room_bridge.tscn")
var room_unstable_scene: PackedScene = load("res://src/room3d/room_unstable.tscn")

func _init(p_room: Room) -> void:
	room = p_room
	for i in range(Room.ROOM_SIZE):
		for j in range(Room.ROOM_SIZE):
			match room.layout[i][j]:
				Room.Tiles.GROUND:
					add_tile(i, j, room_block_scene)
				Room.Tiles.BRIDGE:
					add_tile(i, j, room_bridge_scene)
				Room.Tiles.UNSTABLE:
					add_tile(i, j, room_unstable_scene)
				Room.Tiles.EMPTY:
					add_tile(i, j, room_barrier_scene)


func add_tile(x: int, z: int, tile: PackedScene):
	var t = tile.instantiate()
	t.position.x = x
	t.position.z = z
	add_child(t)
