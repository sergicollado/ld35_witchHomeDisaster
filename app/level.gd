
extends Node2D

var current_room = 0
var SIZE = 512
var exit = false

onready var player = get_node("Witch")
onready var cam = get_node("Camera2D")
onready var current_cam = cam
onready var info = get_node("CanvasLayer/Control/messages")
onready var frog = load("res://characters/frog.tscn")
onready var fli = load("res://characters/flies.tscn")
onready var changeTimer = get_node("ChangeTimer")


var last_room = 0

func _ready():
	Globals.set("Level", self)
	Globals.set("Player", player)
	music.play("Game")
	global.restart()
	append_frogs_and_flies()
	for room in get_tree().get_nodes_in_group("rooms"):
		room.connect("current_room", self, "_enter_room")
		room.connect("exit_room", self, "_exit_room")
	
	get_node("MapGenerator").connect('shuffled',self, "set_change_timer")
	set_process(true)
	set_process_input(true)
	set_change_timer()


func set_change_timer():
	changeTimer.set_wait_time(rand_range(0,20))
	changeTimer.start()
	yield(changeTimer,'timeout')
	get_node("MapGenerator").shuffle()
			
func append_frogs_and_flies():
	randomize()
	for i in range(0, int(config.RECIPE_LEGS)*7):
		var nFrog = frog.instance()
		var pos = Vector2(randi() % int(config.HOUSE_SIZE.x), randi() % int(config.HOUSE_SIZE.y))
		nFrog.set_pos(pos)
		add_child(nFrog)
	randomize()
	for i in range(0, int(config.RECIPE_WINGS)*7):
		var nFli = fli.instance()
		var pos = Vector2(randi() % int(config.HOUSE_SIZE.x), randi() % int(config.HOUSE_SIZE.y)) 
		nFli.set_pos(pos)
		add_child(nFli)
			
func _input(ev):
	if ev.is_action_released("ui_accept") and player.status == player.STATUS_DEAD:
		get_tree().reload_current_scene()
	if ev.is_action_released("ui_cancel"):
		get_tree().reload_current_scene()
		
func _exit_room(room_number):
	exit = current_room == room_number
	
func _enter_room(room):
	exit = false
	current_room = room.room_number
	get_node("CanvasLayer/Control/RoomNumber").set_text(str(current_room))
	print(room.get_pos())
	if current_cam.get_global_pos() == room.get_pos()+Vector2(256, 256):
		return
	cam.go_to(current_cam.get_global_pos(), room.get_pos()+Vector2(256, 256))
	
func _show_message(message):
	info.set_text(message)
	get_node("MessagesTimer").start()
	yield(get_node("MessagesTimer"), 'timeout')
	info.set_text('')

func set_game_over():
#	set_process(false)
	pass

func _process(delta):
	if player.status == player.STATUS_DEAD:
		return set_game_over()
	if exit:
		get_node("Witch/Camera2D").make_current()
		current_cam = get_node("Witch/Camera2D")
		if not music.get_node("Moon").is_playing():
			music.play("Moon")
	else:
		cam.make_current() 
		current_cam = cam
	
	get_node("CanvasLayer/Control/TimeToChange").set_text(str(changeTimer.get_time_left()))
	get_node("CanvasLayer/Control/RecipeLegs").set_text(config.RECIPE_LEGS+'/'+str(global.recipe.frog_legs))
	get_node("CanvasLayer/Control/RecipeWings").set_text(config.RECIPE_WINGS+'/'+str(global.recipe.fly_wings))

func is_recipe_complete():
	var is_complete = global.recipe.frog_legs == 0 and global.recipe.fly_wings == 0
	if is_complete:
		_show_message("recipe complete")
	return is_complete

func recipe_incomplete(): 
	_show_message("search ingredients")
