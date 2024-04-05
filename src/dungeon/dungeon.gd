class_name Dungeon

static var directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
var random: RandomNumberGenerator

var max_dimensions: Vector2i
var room_nr: int
var boss_dist: int

var rooms: Dictionary

func _init(max_dimensions: Vector2i, room_nr: int, boos_dist: int, seed = null):
	self.max_dimensions = max_dimensions
	self.room_nr = room_nr
	self.boss_dist = boss_dist
	
	self.random = RandomNumberGenerator.new()
	if seed:
		self.random.seed = seed
	else:
		self.random.randomize()
		
func generate_dungeon():
	var temp_coords: Vector2i = get_random_point()
	while self.rooms.has(hash(temp_coords)):
		temp_coords = get_random_point()
	add_room(temp_coords)
	
	var current_rooms = self.room_nr - 1
	while current_rooms > 0:
		var new_room = get_random_neighbour(temp_coords)
		while self.rooms.has(hash(new_room)):
			new_room = get_random_neighbour(temp_coords)
		add_room(new_room)
		
		current_rooms -= 1
		temp_coords = new_room
	
	for room in rooms:
		print(rooms[room].coords)

func add_room(coords: Vector2i):
		self.rooms[hash(coords)] = Room.new(coords)

func get_random_neighbour(coords: Vector2i):
	var d = Dungeon.directions[self.random.randi() % Dungeon.directions.size()]
	var neighbour = coords + Vector2i(d[0], d[1])
	while neighbour.x < 0 or neighbour.y < 0 or neighbour.x > self.max_dimensions.x or neighbour.y > self.max_dimensions.y:
		d = Dungeon.directions[self.random.randi() % Dungeon.directions.size()]
		neighbour = coords + Vector2i(d[0], d[1])
	return neighbour

func get_random_point():
	return Vector2i(self.random.randi() % self.max_dimensions[0],
	 self.random.randi() % self.max_dimensions[1])
