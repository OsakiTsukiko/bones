extends Node3D
class_name Room3D

var room: Room
var room_block_scene: PackedScene = load("res://src/room3d/room_block.tscn")
var room_barrier_scene: PackedScene = load("res://src/room3d/room_barrier.tscn")

func _init(p_room: Room) -> void:
	room = p_room
	for i in range(Room.ROOM_SIZE):
		for j in range(Room.ROOM_SIZE):
			if room.layout[i][j]:
				var b = room_block_scene.instantiate()
				b.position.x = i
				b.position.z = j
				add_child(b)
			else:
				var brr = room_barrier_scene.instantiate()
				brr.position.x = i
				brr.position.z = j
				add_child(brr)
