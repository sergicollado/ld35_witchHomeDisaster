
extends Node2D



var room_size = config.ROOM_SIZE
var TILE_SIZE = config.TILE_SIZE
var LEVEL_GRID = config.LEVEL_GRID
var TILE_WALL = config.TILE_WALL
var TILE_DOOR = config.TILE_DOOR
var MAX_DOOR_SIZE = config.MAX_DOOR_SIZE
var previus_doors = []
onready var room_template = load("res://tiles/room.tscn")

func _ready():
	randomize()
	var count = 0
	for v_cell in range(LEVEL_GRID.x):
		previus_doors.append([])
		for h_cell in range(LEVEL_GRID.y):
			
			var current_doors = generate_doors()

			if v_cell == 0 and h_cell>0:
				current_doors.top = previus_doors[0][h_cell-1].bottom
			if v_cell > 0 and h_cell == 0:
				current_doors.left = previus_doors[v_cell-1][0].right
			if v_cell > 0 and h_cell > 0:
				current_doors.top = previus_doors[v_cell][h_cell-1].bottom
				current_doors.left = previus_doors[v_cell-1][h_cell].right
				
			previus_doors[v_cell].append( current_doors)
			var room = generate_room(Vector2(v_cell*room_size,h_cell*room_size), current_doors)
			
			room.room_number= count
			add_child(room)
			count +=1
			
func shuffle():
	randomize()
	var list = get_children()
	list.sort_custom(self,"_suffle_two_elements")

	var count = 0
	for v_cell in range(LEVEL_GRID.x):
		for h_cell in range(LEVEL_GRID.y):
			list[count].set_pos(Vector2(v_cell*room_size*TILE_SIZE,h_cell*room_size*TILE_SIZE))
			count += 1

func _suffle_two_elements(a,b):
	return randf()>0.5

func _room_enter(body, area):
	print(area.room_number)
func createArea():
	var area = Area2D.new()
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(TILE_SIZE*room_size, TILE_SIZE*room_size))
	area.add_shape(shape)
	return area
func generate_doors():
	var doors_list = ['top','bottom','left','right']
	var doors = Dictionary()
	for door in doors_list:
		doors[door] = generate_door()

	return doors
	
func generate_door():
	return {
		'size':rand_range(1,MAX_DOOR_SIZE),
		'position': rand_range(4,10)
	}

func generate_room(origin,doors):
	var tilemap = room_template.instance()

	_generate_horizontal_wall(doors.top.position, doors.top.size, 0,tilemap)
	_generate_horizontal_wall(doors.bottom.position, doors.bottom.size, room_size-1,tilemap)
	_generate_vertical_wall(doors.left.position,doors.left.size,0, tilemap)
	_generate_vertical_wall(doors.right.position,doors.right.size,  room_size-1, tilemap)
	tilemap.set_pos(Vector2(origin.x*TILE_SIZE,origin.y*TILE_SIZE))
	return tilemap
	
func _generate_horizontal_wall(door_position, door_size, position, tilemap):
	for col in range(room_size):
		if col < door_position or col >= door_position + door_size:
			tilemap.set_cell(col, position, config.TILE_FLOOR)
#		else:
#			tilemap.set_cell(col, position, TILE_DOOR)
	
func _generate_vertical_wall(door_position, door_size, position, tilemap):
	for row in range(1,room_size-1):
		if row < door_position or row >= door_position + door_size:
			tilemap.set_cell(position, row , TILE_WALL)
#		else:
#			tilemap.set_cell(position, row , TILE_DOOR)