
extends TileMap

# member variables here, example:
# var a=2
# var b="textvar"
var top = {
	"door_size": 1,
	"door_position" : 6
}
var bottom = {
	"door_size": 1,
	"door_position" : 7
}
var left = {
	"door_size": 1,
	"door_position" : 7
}
var right = {
	"door_size": 1,
	"door_position" : 7
}

var room_size = 16
var LEVEL_GRID = Vector2(5,3)
var TILE_WALL = 0
var TILE_DOOR = 4
var MAX_DOOR_SIZE = 5
var previus_doors = []	

func _ready():
	randomize()
	for v_cell in range(LEVEL_GRID.x):
		previus_doors.append([])
		for h_cell in range(LEVEL_GRID.y):
			var limits = []
			if v_cell == 0:
				limits.append('left')
			if v_cell == LEVEL_GRID.x-1:
				limits.append('right')
			if h_cell == 0:
				limits.append("top")
			if h_cell == LEVEL_GRID.y-1:
				limits.append('bottom')
			
			var current_doors = generate_doors(limits)

			if v_cell == 0 and h_cell>0:
				current_doors.top = previus_doors[0][h_cell-1].bottom
			if v_cell > 0 and h_cell == 0:
				current_doors.left = previus_doors[v_cell-1][0].right
			if v_cell > 0 and h_cell > 0:
				current_doors.top = previus_doors[v_cell][h_cell-1].bottom
				current_doors.left = previus_doors[v_cell-1][h_cell].right
				
			previus_doors[v_cell].append( current_doors)
			generate_room(Vector2(v_cell*room_size-1,h_cell*room_size-1), current_doors)

func generate_doors(limits):
	var doors_list = ['top','bottom','left','right']
	var doors = Dictionary()
	
	for door in doors_list:
		if door in limits:
			doors[door] = {'size':0,'position':0}
		else:
			doors[door] = generate_door()

	return doors
	
func generate_door():
	return {
		'size':rand_range(1,MAX_DOOR_SIZE),
		'position': rand_range(4,10)
	}

func generate_room(origin,doors):
	var tilemap = TileMap.new()
	tilemap.set_cell_size(Vector2(32,32))
	tilemap.set_tileset(get_tileset())
	
	_generate_horizontal_wall(doors.top.position, doors.top.size, 0,tilemap)
	_generate_horizontal_wall(doors.bottom.position, doors.bottom.size, room_size-1,tilemap)
	_generate_vertical_wall(doors.left.position,doors.left.size,0, tilemap)
	_generate_vertical_wall(doors.right.position,doors.right.size,  room_size-1, tilemap)
	
	tilemap.set_pos(Vector2(origin.x*32,origin.y*32))
	add_child(tilemap)
	
func _generate_horizontal_wall(door_position, door_size, position, tilemap):
	for col in range(room_size):
		if col < door_position or col >= door_position + door_size:
			tilemap.set_cell(col, position, TILE_WALL)
		else:
			tilemap.set_cell(col, position, TILE_DOOR)
	
func _generate_vertical_wall(door_position, door_size, position, tilemap):
	for row in range(room_size):
		if row < door_position or row >= door_position + door_size:
			tilemap.set_cell(position, row , TILE_WALL)
		else:
			tilemap.set_cell(position, row , TILE_DOOR)