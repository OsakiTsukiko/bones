extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var dgn = Dungeon.new(Vector2i(15, 15), 5, 5, hash("gimme negative plss"))
	dgn.generate_dungeon()
	
	var r: Room;
	for rkey in dgn.rooms:
		r = dgn.rooms[rkey]
		break
	 
	var idk = Room3D.new(r)
	add_child(idk)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
