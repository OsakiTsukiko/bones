class_name Room

static var ROOM_SIZE = 15
static var SAFE_AREA_SIZE = 5
static var directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

var coords: Vector2i
var neighbours: int
var layout: Array[Array]

var random: RandomNumberGenerator

func _init(coords: Vector2i):
	self.random = RandomNumberGenerator.new()
	
	self.coords = coords
	init_layout()
	generate_room()

func init_layout():
	for i in range(Room.ROOM_SIZE):
		self.layout.append([])
		for j in range(Room.ROOM_SIZE):
			self.layout[i].append(false)

func add_safe_area():
	for i in range(Room.SAFE_AREA_SIZE):
		for j in range(Room.SAFE_AREA_SIZE):
			self.layout[Room.SAFE_AREA_SIZE + i][ Room.SAFE_AREA_SIZE + j] = true
			
func add_safe_area_circle():
	# Experimental circle safe area
	var radius = 3
	for i in range(Room.ROOM_SIZE/2-radius, Room.ROOM_SIZE/2+radius+1):
		for j in range(Room.ROOM_SIZE/2-radius, Room.ROOM_SIZE/2+radius+1):
			if (i-Room.ROOM_SIZE/2)*(i-Room.ROOM_SIZE/2) + (j-Room.ROOM_SIZE/2)*(j-Room.ROOM_SIZE/2) <= radius*radius:
				self.layout[i][j] = true

func do_edge_expansion():
	for i in range(2, Room.ROOM_SIZE-3):
		for j in range(2, Room.ROOM_SIZE-3):
			if self.layout[i][j]:
				for k in Room.directions:
					if !self.layout[i+k[0]][j+k[1]] and self.random.randf() < 0.1:
						self.layout[i+k[0]][j+k[1]] = true
						break
						
func generate_room():
	add_safe_area_circle()
	for i in range(5):
		do_edge_expansion()
	
static func print_room_layout(room: Room):
	print(room.coords)
	var s = ""
	for i in range(Room.ROOM_SIZE):
		s = ""
		for j in range(Room.ROOM_SIZE):
			if room.layout[i][j]:
				s += "*"
			else: 
				s += "."
		print(s)
