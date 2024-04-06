class_name Dungeon

static var directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
var random: RandomNumberGenerator

var max_dimensions: Vector2i
var room_nr: int
var boss_dist: int

var rooms: Dictionary

func _init(max_dimensions: Vector2i, room_nr: int, seed = null):
	self.max_dimensions = max_dimensions
	self.room_nr = room_nr
	self.boss_dist = boss_dist
	
	self.random = RandomNumberGenerator.new()
	if seed:
		self.random.seed = seed
	else:
		self.random.randomize()
		
func get_room_vec(coords: Vector2i):
	return self.rooms[hash(coords)]
	
func get_room_num(x: int, y: int):
	return self.rooms[hash(Vector2i(x, y))]
		
func generate_dungeon():
	add_room(Vector2i(0, 0), false) # Add start room
	
	var current_rooms = self.room_nr - 1
	while current_rooms > 0:
		add_room(get_random_neighbour(), false)
		current_rooms -= 1

	for room in rooms:
		rooms[room].add_unstable()
	draw_doors()

	var t = longest_leaf(rooms[hash(Vector2i(0, 0))], 0)
	var boss_coords = t[0].coords - t[0].get_neighbours()[0]
	
	add_room(t[0].coords + boss_coords, true)
	match boss_coords:
		Vector2i(0, -1):
			self.rooms[hash(t[0].coords + boss_coords)].add_neighbour('E', 0)
			self.rooms[hash(t[0].coords)].add_neighbour('W', 0)
		Vector2i(0, 1):
			self.rooms[hash(t[0].coords + boss_coords)].add_neighbour('W', 0)
			self.rooms[hash(t[0].coords)].add_neighbour('E', 0)
		Vector2i(-1, 0):
			self.rooms[hash(t[0].coords + boss_coords)].add_neighbour('S', 0)
			self.rooms[hash(t[0].coords)].add_neighbour('N', 0)
		Vector2i(1, 0):
			self.rooms[hash(t[0].coords + boss_coords)].add_neighbour('N', 0)
			self.rooms[hash(t[0].coords)].add_neighbour('S', 0)
	Room.print_room_layout(self.rooms[hash(t[0].coords)])
	Room.print_room_layout(self.rooms[hash(t[0].coords + boss_coords)])
	print_layout()

var vis: Dictionary
func longest_leaf(room: Room, dis: int):
	if room.coords == Vector2i(0, 0):
		for r in rooms:
			vis[r] = false
	
	vis[hash(room.coords)] = true
	print(room)
	var cr: Room = room
	var cx: int = 0
	for n in room.get_neighbours():
		if !vis[hash(n)]:
			var t = longest_leaf(rooms[hash(n)], dis+1)
			if t[1] >= cx:
				cr = t[0]
				cx = t[1]
	return [cr, dis+cx]

func add_room(coords: Vector2i, is_boss: bool):
		self.rooms[hash(coords)] = Room.new(coords, is_boss)

func draw_doors():
	for room in self.rooms:
		var offset
		for d in directions:
			offset = self.random.randi_range(-3, 3)
			if self.rooms.has(hash(self.rooms[room].coords + Vector2i(d[0], d[1]))):
				#print("%s -> %s" % [self.rooms[room], self.rooms[hash(self.rooms[room].coords + Vector2i(d[0], d[1]))]])
				match d:
					[0, 1]:
						if !self.rooms[room].doors.has('E'):
							self.rooms[room].add_neighbour('E', offset)
							self.rooms[hash(self.rooms[room].coords + Vector2i(d[0], d[1]))].add_neighbour('W', offset)
					[0, -1]:
						if !self.rooms[room].doors.has('W'):
							self.rooms[room].add_neighbour('W', offset)
							self.rooms[hash(self.rooms[room].coords + Vector2i(d[0], d[1]))].add_neighbour('E', offset)
					[1, 0]:
						if !self.rooms[room].doors.has('S'):
							self.rooms[room].add_neighbour('S', offset)
							self.rooms[hash(self.rooms[room].coords + Vector2i(d[0], d[1]))].add_neighbour('N', offset)
					[-1, 0]:
						if !self.rooms[room].doors.has('N'):
							self.rooms[room].add_neighbour('N', offset)
							self.rooms[hash(self.rooms[room].coords + Vector2i(d[0], d[1]))].add_neighbour('S', offset)
		
func get_random_neighbour():
	var coords = rooms[rooms.keys()[random.randi() % rooms.size()]].coords
	var direction = Dungeon.directions[self.random.randi() % Dungeon.directions.size()]
	var neighbour = coords + Vector2i(direction[0], direction[1])
	var count = 0
	while count != 1:
		for d in directions:
			var temp_c = neighbour + Vector2i(d[0], d[1])
			if rooms.has(hash(temp_c)):
				count += 1
		
		if count != 1:
			coords = rooms[rooms.keys()[random.randi() % rooms.size()]].coords
			direction = Dungeon.directions[self.random.randi() % Dungeon.directions.size()]
			neighbour = coords + Vector2i(direction[0], direction[1])
			count = 0
	return neighbour

func print_layout():
	var layout: Array[Array]
	for i in range(20):
		layout.append([])
		for j in range(20):
			layout[i].append('.')
	
	for room in rooms:
		var c = rooms[room].coords
		layout[c.x+8][c.y+8] = 'X'
		if rooms[room].is_boss:
			layout[c.x+8][c.y+8] = 'B'
	#for room in rooms:
		#var c = rooms[room].coords
		#if rooms[room].doors.size() == 1:
			#layout[c.x+8][c.y+8] = 'B'
	layout[8][8] = 'O'
	
			
	var s = ""
	for i in range(20):
		s = ""
		for j in range(20):
			s += layout[i][j]
		print(s)
