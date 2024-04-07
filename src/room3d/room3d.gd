extends Node3D
class_name Room3D

var room: Room
var room_block_scene: PackedScene = load("res://src/room3d/room_block.tscn")
var room_barrier_scene: PackedScene = load("res://src/room3d/room_barrier.tscn")
var room_bridge_scene: PackedScene = load("res://src/room3d/room_bridge.tscn")
var room_unstable_scene: PackedScene = load("res://src/room3d/room_unstable.tscn")
var room_door: PackedScene = load("res://src/room3d/room_door.tscn")
var open_room_door: PackedScene = load("res://src/room3d/open_room_door.tscn")

var ground_object_scene: PackedScene = load("res://src/ground_object/ground_object.tscn")

var red_crystal = load("res://assets/misc/crystal_red.png")
var yellow_crystal = load("res://assets/misc/crystal_yellow.png")
var gray_crystal = load("res://assets/misc/crystal_gray.png")
var blue_crystal = load("res://assets/misc/crystal_blue.png")

var future = load("res://assets/misc/future.png")

var dog_scene = load("res://src/dog_enemy/dog_enemy.tscn")

var cadaver_scene: PackedScene = load("res://src/ground_object/cadaver.tscn")

var cadavers: Array[Node3D] = []

enum CrystalE {
	RED,
	YELLOW,
	BLUE,
	GRAY,
	NONE
}

var mobs_remaining = 0

var n_bruv_blocks: Array[Node3D] = []
var s_bruv_blocks: Array[Node3D] = []
var w_bruv_blocks: Array[Node3D] = []
var e_bruv_blocks: Array[Node3D] = []

var directions_g: Array[String]

var from: String
var ppos: Vector3 = Vector3(-1, -1, -1)
var dv: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]

func _init(p_room: Room, directions: Array[String], has_crystal: CrystalE = CrystalE.NONE) -> void:
	room = p_room
		# if the room is boss then create future device in the middle
	
	
	if SceneManager.is_dungeon_future:
		has_crystal = CrystalE.GRAY

	if room.is_boss:
		var future_instance = ground_object_scene.instantiate()
		future_instance._init_instance(0.5, future, .2)
		future_instance.position = Vector3(Room.ROOM_SIZE/2, 1.5, Room.ROOM_SIZE/2)
		add_child(future_instance)
		future_instance.body_entered.connect(SceneManager.change_to_future)
		
		has_crystal = Room3D.CrystalE.NONE
	
	if SceneManager.is_dungeon_future and room.coords == Vector2i(0, 0):
		has_crystal = CrystalE.NONE
		
		var future_instance = ground_object_scene.instantiate()
		future_instance._init_instance(0.5, future, .2)
		future_instance.position = Vector3(Room.ROOM_SIZE/2, 1.5, Room.ROOM_SIZE/2)
		add_child(future_instance)
		future_instance.body_entered.connect(SceneManager.exit_dungeon)
	
	directions_g = directions.duplicate(true)
	for i in range(Room.ROOM_SIZE):
		for j in range(Room.ROOM_SIZE):
			match room.layout[i][j]:
				Room.Tiles.GROUND:
					add_tile(i, j, room_block_scene)
				Room.Tiles.BRIDGE:
					if room.n_bridges.has(Vector2i(i, j)):
						if directions.has("N"):
							if (i == 0):
								if has_crystal == CrystalE.RED:
									var node = add_tile(i, j, open_room_door)
									node.dir = "N"
									ppos = node.position
								else:
									var node = add_tile(i, j, room_door)
									dv[0] = node.position
									node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("N"))
									
							else:
								add_tile(i, j, room_bridge_scene)
						else:
							n_bruv_blocks.append(add_tile(i, j, room_barrier_scene))
					
					if (room.s_bridges.has(Vector2i(i, j))):
						if directions.has("S"):
							if (i == Room.ROOM_SIZE - 1):
								if has_crystal == CrystalE.RED:
									var node = add_tile(i, j, open_room_door)
									node.dir = "S"
									ppos = node.position
								else:
									var node = add_tile(i, j, room_door)
									dv[1] = node.position
									node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("S"))
							else:
								add_tile(i, j, room_bridge_scene)
						else:
							s_bruv_blocks.append(add_tile(i, j, room_barrier_scene))
					
					if (room.w_bridges.has(Vector2i(i, j))):
						if directions.has("W"):
							if (j == 0):
								if has_crystal == CrystalE.RED:
									var node = add_tile(i, j, open_room_door)
									node.dir = "W"
									ppos = node.position
								else:
									var node = add_tile(i, j, room_door)
									dv[2] = node.position
									node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("W"))
							else:
								add_tile(i, j, room_bridge_scene)
						else:
							w_bruv_blocks.append(add_tile(i, j, room_barrier_scene))
					
					if (room.e_bridges.has(Vector2i(i, j))):
						if directions.has("E"):
							if (j == Room.ROOM_SIZE - 1):
								if has_crystal == CrystalE.RED:
									var node = add_tile(i, j, open_room_door)
									node.dir = "E"
									ppos = node.position
								else:
									var node = add_tile(i, j, room_door)
									dv[3] = node.position
									node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("E"))
							else:
								add_tile(i, j, room_bridge_scene)
						else:
							e_bruv_blocks.append(add_tile(i, j, room_barrier_scene))
							
				Room.Tiles.UNSTABLE:
					add_tile(i, j, room_unstable_scene)
				Room.Tiles.EMPTY:
					add_tile(i, j, room_barrier_scene)
	
	if SceneManager.is_dungeon_future:
		mobs_remaining = 0
	else:
		mobs_remaining = randi()%3+1
	print("MOBS: ", mobs_remaining)
	
	match has_crystal:
		CrystalE.RED:
			var crystal = ground_object_scene.instantiate()
			crystal._init_instance(0.5, red_crystal, .2)
			crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
			add_child(crystal)
			crystal.connect("body_entered", Callable(self, "spawn_mob").bind(crystal))
		
		CrystalE.YELLOW:
			var crystal = ground_object_scene.instantiate()
			crystal._init_instance(0.5, yellow_crystal, .2)
			crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
			add_child(crystal)
		
		CrystalE.BLUE:
			var crystal = ground_object_scene.instantiate()
			crystal._init_instance(0.5, blue_crystal, .2)
			crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
			add_child(crystal)
		
		CrystalE.GRAY:
			var crystal = ground_object_scene.instantiate()
			crystal._init_instance(0.5, gray_crystal, .2)
			crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
			add_child(crystal)

var mobs_to_spawn: int
func spawn_mob(idk, ground_object: Area3D):
	print("Mobs remaining: ", mobs_remaining)
	if (mobs_remaining <= 0):
		ground_object.queue_free()
		var crystal = ground_object_scene.instantiate()
		crystal._init_instance(0.5, yellow_crystal, .2)
		crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
		add_child(crystal)
		crystal.connect("body_entered", Callable(self, "next_level").bind(crystal))
	else:
		var mbs_to_spawn = 1
		if (mobs_remaining >= 2):
			mbs_to_spawn = randi()%2 + 1
		mobs_remaining -= mbs_to_spawn
		mobs_to_spawn = mbs_to_spawn
		print("Spawning ", mbs_to_spawn, " mobs")
		ground_object.queue_free()
		
		var crystal = ground_object_scene.instantiate()
		crystal._init_instance(0.5, blue_crystal, .2)
		crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
		add_child(crystal)
		
		if (mbs_to_spawn == 2):
			var d1 = dog_scene.instantiate()
			d1.init(SceneManager.get_player())
			add_child(d1)
			d1.position = Vector3(Room.ROOM_SIZE/2 + .5, 1, Room.ROOM_SIZE/2)
			d1.connect("dog_death", Callable(self, "dog_death").bind(crystal, d1))
			var d2 = dog_scene.instantiate()
			d2.init(SceneManager.get_player())
			add_child(d2)
			d2.position = Vector3(Room.ROOM_SIZE/2 - .5, 1, Room.ROOM_SIZE/2)
			d2.connect("dog_death", Callable(self, "dog_death").bind(crystal, d2))
		else:
			var d: Dog = dog_scene.instantiate()
			d.init(SceneManager.get_player())
			add_child(d)
			d.position = Vector3(Room.ROOM_SIZE/2, 1, Room.ROOM_SIZE/2)
			d.connect("dog_death", Callable(self, "dog_death").bind(crystal, d))

func dog_death(crystal: Area3D, dog: Dog):
	print("DOG DEATH SIGNAL")
	mobs_to_spawn -= 1
	var cadaver: Node3D = cadaver_scene.instantiate()
	cadavers.append(cadaver)
	add_child(cadaver)
	cadaver.position = dog.position
	dog.queue_free()
	
	if mobs_to_spawn > 0:
		return
	
	if (mobs_remaining <= 0):
		crystal.queue_free()
		var crystal_yellow = ground_object_scene.instantiate()
		crystal_yellow._init_instance(0.5, yellow_crystal, .2)
		crystal_yellow.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
		add_child(crystal_yellow)
		crystal_yellow.connect("body_entered", Callable(self, "next_level").bind(crystal_yellow))
	else:
		crystal.queue_free()
		var crystal_red = ground_object_scene.instantiate()
		crystal_red._init_instance(0.5, red_crystal, .2)
		crystal_red.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
		add_child(crystal_red)
		crystal_red.connect("body_entered", Callable(self, "next_wave").bind(crystal_red))

func next_wave(idk, crystal: Node3D):
	#crystal.queue_free()
	spawn_mob(null, crystal)

func next_level(idk, ground_object: Area3D):
	ground_object.queue_free()
	var crystal = ground_object_scene.instantiate()
	crystal._init_instance(0.5, gray_crystal, .2)
	crystal.position = Vector3(Room.ROOM_SIZE/2, 2.5, Room.ROOM_SIZE/2)
	add_child(crystal)
	
	#room.doors.has("N")
	#for block: Vector2i in room.n_bridges:
		#block.visible = true
	if (room.doors.has("N")):
		if !directions_g.has("N"):
			directions_g.append("N")
		for block: Node3D in n_bruv_blocks:
			if (block.position.x == 0):
				var node = add_tile(block.position.x, block.position.z, room_door)
				node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("N"))
			else: 	
				add_tile(block.position.x, block.position.z, room_bridge_scene)
			block.queue_free()
	
	if (room.doors.has("S")):
		if !directions_g.has("S"):
			directions_g.append("S")
		for block: Node3D in s_bruv_blocks:
			if (block.position.x == Room.ROOM_SIZE - 1):
				var node = add_tile(block.position.x, block.position.z, room_door)
				node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("S"))
			else:
				add_tile(block.position.x, block.position.z, room_bridge_scene)
			block.queue_free()
	
	if (room.doors.has("W")):
		if !directions_g.has("W"):
			directions_g.append("W")
		for block: Node3D in w_bruv_blocks:
			if (block.position.z == 0):
				var node = add_tile(block.position.x, block.position.z, room_door)
				node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("W"))
			else: 
				add_tile(block.position.x, block.position.z, room_bridge_scene)
			block.queue_free()
			
	if (room.doors.has("E")):
		if !directions_g.has("E"):
			directions_g.append("E")
		for block: Node3D in e_bruv_blocks:
			if (block.position.z == Room.ROOM_SIZE - 1):
				var node = add_tile(block.position.x, block.position.z, room_door)
				node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind("E"))
			else: 
				add_tile(block.position.x, block.position.z, room_bridge_scene)
			block.queue_free()
	
	for child in get_children():
		if (child.is_in_group("open_door_room")):
			var node = add_tile(child.position.x, child.position.z, room_door)
			node.get_node("DOOR").connect("body_entered", Callable(self, "do_door").bind(child.dir))
			child.queue_free()
		

func add_tile(x: int, z: int, tile: PackedScene) -> Node3D:
	var t = tile.instantiate()
	t.position.x = x
	t.position.z = z
	add_child(t)
	return t

func do_door(idk, d: String):
	#if get_parent().has_meta("prepare_to_go"):
		#get_parent().prepare_to_go()
	var cad_pos = []
	if !SceneManager.is_dungeon_future:
		for cadaver in cadavers:
			cad_pos.append(cadaver.position)
	print(directions_g)
	print({"cadavers": cad_pos, "doors": directions_g})
	SceneManager.save_scene_with_data(str(hash(room.coords)), {"cadavers": cad_pos, "doors": directions_g})
	print("GOING ", d)
	print("GOING ", d)
	print("GOING ", d)
	print("GOING ", d)
	print("GOING ", d)
	match d:
		"N":
			var vc: Array[String] = ["S"]
			SceneManager.enter_room((room.coords + Vector2i(-1, 0)), "S", vc)
		"S":
			var vc: Array[String] = ["N"]
			SceneManager.enter_room((room.coords + Vector2i(1, 0)), "N", vc)
		"W":
			var vc: Array[String] = ["E"]
			SceneManager.enter_room((room.coords + Vector2i(0, -1)), "E", vc)
		"E":
			var vc: Array[String] = ["W"]
			SceneManager.enter_room((room.coords + Vector2i(0, 1)), "W", vc)
