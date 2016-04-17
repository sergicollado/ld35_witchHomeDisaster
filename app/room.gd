
extends TileMap

signal current_room
signal exit_room
var room_number

func _ready():
	add_to_group("rooms")
	get_node("Area2D").connect("body_enter",self, "_send_current_room_signal")
	get_node("Area2D").connect("body_exit",self, "_exit_room")
	generate_room()

func generate_room():

	for cell in range(0,randi() % 10):
		var platform = get_platform()
		set_platform(platform)

func set_platform(platform):
	var is_floor = randi() % 3
	if is_floor:
		if platform.origin.x + platform.size > config.ROOM_SIZE-1:
			platform.size = (platform.origin.x + platform.size) - (config.ROOM_SIZE-1)
		for cell  in range(0,platform.size):
			set_cell(platform.origin.x+cell,platform.origin.y, config.TILE_FLOOR)
	else:
		if platform.origin.y + platform.size > config.ROOM_SIZE-1:
			platform.size = (platform.origin.y + platform.size) - (config.ROOM_SIZE-1)
		for cell  in range(0,platform.size):
			set_cell(platform.origin.x,platform.origin.y+cell, config.TILE_WALL_2)
func get_platform():
	return { 'origin': Vector2( (randi() % config.ROOM_SIZE-2)+1,randi() % config.ROOM_SIZE), 'size':  randi() % 4}
	
func _send_current_room_signal(body):
	if body.get_name() == "Witch":
		emit_signal("current_room", self)

func _exit_room(body):
	if body.get_name() == "Witch":
		emit_signal("exit_room",room_number)
