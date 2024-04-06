class_name Room

var random: RandomNumberGenerator
static var ROOM_SIZE = 25
static var SAFE_AREA_SIZE = 5
static var directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

var coords: Vector2i
var is_boss: bool
var layout: Array[Array]
var doors: Dictionary

enum Tiles {
	EMPTY,
	GROUND,
	BRIDGE,
	UNSTABLE
}

func _init(coords: Vector2i, is_boss: bool):
	self.random = RandomNumberGenerator.new()
	self.coords = coords
	self.is_boss = is_boss
	
	init_layout()
	generate_room()

func init_layout():
	for i in range(Room.ROOM_SIZE):
		self.layout.append([])
		for j in range(Room.ROOM_SIZE):
			self.layout[i].append(Tiles.EMPTY)

func add_safe_area():
	for i in range(Room.SAFE_AREA_SIZE):
		for j in range(Room.SAFE_AREA_SIZE):
			self.layout[Room.SAFE_AREA_SIZE + i][ Room.SAFE_AREA_SIZE + j] = Tiles.GROUND
			
func add_safe_area_circle():
	# Experimental circle safe area
	var radius = 5
	if is_boss:
		radius = 2
	for i in range(Room.ROOM_SIZE/2-radius, Room.ROOM_SIZE/2+radius+1):
		for j in range(Room.ROOM_SIZE/2-radius, Room.ROOM_SIZE/2+radius+1):
			if (i-Room.ROOM_SIZE/2)*(i-Room.ROOM_SIZE/2) + (j-Room.ROOM_SIZE/2)*(j-Room.ROOM_SIZE/2) <= radius*radius:
				self.layout[i][j] = Tiles.GROUND

func do_edge_expansion():
	for i in range(2, Room.ROOM_SIZE-3):
		for j in range(2, Room.ROOM_SIZE-3):
			if self.layout[i][j] != Tiles.EMPTY: # TODO: make sure to check for other tiles
				for k in Room.directions:
					if self.layout[i+k[0]][j+k[1]] == Tiles.EMPTY and self.random.randf() < 0.1:
						self.layout[i+k[0]][j+k[1]] = Tiles.GROUND
						break
						
func generate_room():
	add_safe_area_circle()
	if !is_boss:
		for i in range(7):
			do_edge_expansion()

func add_neighbour(direction, offset):
	match direction:
		'N':
			var pos = Vector2i(0, Room.ROOM_SIZE/2+offset)
			while self.layout[pos.x][pos.y] != Tiles.GROUND and pos.x < Room.ROOM_SIZE/2:
				self.layout[pos.x][pos.y] = Tiles.BRIDGE
				pos.x += 1
			self.doors['N'] = offset
		'S':
			var pos = Vector2i(Room.ROOM_SIZE-1, Room.ROOM_SIZE/2+offset)
			while self.layout[pos.x][pos.y] != Tiles.GROUND and pos.x > Room.ROOM_SIZE/2:
				self.layout[pos.x][pos.y] = Tiles.BRIDGE
				pos.x -= 1
			self.doors['S'] = offset
		'E':
			var pos = Vector2i(Room.ROOM_SIZE/2+offset, Room.ROOM_SIZE-1)
			while self.layout[pos.x][pos.y] != Tiles.GROUND and pos.y > Room.ROOM_SIZE/2:
				self.layout[pos.x][pos.y] = Tiles.BRIDGE
				pos.y -= 1
			self.doors['E'] = offset
		'W':
			var pos = Vector2i(Room.ROOM_SIZE/2+offset, 0)
			while self.layout[pos.x][pos.y] != Tiles.GROUND and pos.y < Room.ROOM_SIZE/2:
				self.layout[pos.x][pos.y] = Tiles.BRIDGE
				pos.y += 1
			self.doors['W'] = offset

func add_unstable():
	for i in range(Room.ROOM_SIZE):
		for j in range(Room.ROOM_SIZE):
			if self.layout[i][j] == Tiles.GROUND:
				var valid = false
				for k in Room.directions:
					if self.layout[i+k[0]][j+k[1]] == Tiles.EMPTY:
						valid = true
				for k in Room.directions:
					if self.layout[i+k[0]][j+k[1]] == Tiles.BRIDGE:
						valid = false
				if valid and self.random.randf() < 0.4:
					self.layout[i][j] = Tiles.UNSTABLE

func get_neighbours():
	var neighbours: Array[Vector2i]
	for d in doors:
		match d:
			'N':
				neighbours.append(coords + Vector2i(-1, 0))
			'S':
				neighbours.append(coords + Vector2i(1, 0))
			'E':
				neighbours.append(coords + Vector2i(0, 1))
			'W':
				neighbours.append(coords + Vector2i(0, -1))
	return neighbours

func get_neighbours_hashed():
	var neighbours: Array[String]
	for d in doors:
		match d:
			'N':
				neighbours.append(hash(coords + Vector2i(-1, 0)))
			'S':
				neighbours.append(hash(coords + Vector2i(1, 0)))
			'E':
				neighbours.append(hash(coords + Vector2i(0, 1)))
			'W':
				neighbours.append(hash(coords + Vector2i(0, -1)))
	return neighbours

func _to_string():
	return "(%s, %s)" % [self.coords.x, self.coords.y]

static func print_room_layout(room: Room):
	print(room.coords)
	var s = ""
	for i in range(Room.ROOM_SIZE):
		s = ""
		for j in range(Room.ROOM_SIZE):
			match room.layout[i][j]:
				Room.Tiles.GROUND:
					s += "*"
				Room.Tiles.BRIDGE:
					s += "="
				Room.Tiles.UNSTABLE:
					s += "+"
				Room.Tiles.EMPTY:
					s += "."
		print(s)
