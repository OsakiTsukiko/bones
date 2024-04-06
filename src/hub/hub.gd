extends Node3D


var test_scene: PackedScene = preload("res://src/test/test.tscn")

func setup_room():
	var room: Room = Room.new(Vector2i(0, 0));
	var room_3d: Room3D = Room3D.new(room)

	add_child(room_3d);

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_room();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_portal_body_entered(body):
	print(1, body)
	if body == $Player:
		call_deferred("_change_scene_to", test_scene)

func _change_scene_to(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
