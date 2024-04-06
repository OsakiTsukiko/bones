extends Node3D

@onready var test_scene: PackedScene = preload("res://src/test/test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var room: Room = Room.new(Vector2i(0, 0));
	var room_3d: Room3D = Room3D.new(room)

	add_child(room_3d);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_portal_body_entered(body):
	if body == $Player:
		get_tree().change_scene_to_packed(test_scene)
