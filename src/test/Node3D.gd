extends Node3D

var dog_scene: PackedScene = load("res://src/dog_enemy/dog_enemy.tscn")

@onready var blks = $blks

# Called when the node enters the scene tree for the first time.
func _ready():
	var dgn = Dungeon.new(Vector2i(15, 15), 15)
	dgn.generate_dungeon()
	
	var r: Room;
	for rkey in dgn.rooms:
		r = dgn.rooms[rkey]
		break
	 
	var idk = Room3D.new(r, [])
	blks.add_child(idk)
	
	var dog = dog_scene.instantiate()
	dog.init($Player)
	dog.position = Vector3(14, 1, 14)
	add_child(dog)
	
	var dog2 = dog_scene.instantiate()
	dog2.init($Player)
	dog2.position = Vector3(15, 1, 14)
	add_child(dog2)
	
	$GroundItem._init_instance(0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
