extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var room: Room = Room.new(Vector2i(0, 0));
	var room_3d: Room3D = Room3D.new(room)

	add_child(room_3d);
	Room.print_room_layout(room);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
