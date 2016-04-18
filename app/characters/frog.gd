
extends RigidBody2D

var STATUS_NORMAL = 0
var STATUS_HUNTED = 1
var status = STATUS_NORMAL
var HABILITY_NONE = 0
var HABILITY_JUMP = 1
var HABILITY_SHOOT = 2

var hability = HABILITY_NONE 

onready var wings_packed = load("res://props/legs.tscn")
onready var gun = load("res://props/gun.scn")
onready var ray = get_node("RayCast2D")
onready var timer = get_node("Timer")
onready var player = get_node("AnimationPlayer")
var force = 300

func _ready():
	add_to_group("mortal")
	randomize()
	get_node("VisibilityNotifier2D").connect("enter_screen",self, "start")

func start():
	set_timer()
	set_fixed_process(true)
	
func _fixed_process(delta):
	if ray.is_colliding() and hability == HABILITY_NONE and status!= STATUS_HUNTED and !player.is_playing():
		player.play("idle")
		
func set_timer():
	timer.start()
	yield(timer, 'timeout')
	randomize()
	var action =rand_range(0,1)
	print(action)
	var target = Globals.get("Player")
	if action > 0.5:
		push(target)
	else:
		shoot(target)
		
func shoot(target):
	
	var new_gun = gun.instance()
	var nDir = target.get_pos()-get_pos()
	new_gun.dir = nDir.normalized()
	new_gun.player_target = true
	check_scale(nDir)
		
	new_gun.set_pos(get_node("Sprite/Position2D").get_global_pos())
	new_gun.set_scale(Vector2(0.5,0.5))
	Globals.get("Level").add_child(new_gun)
	hability = HABILITY_SHOOT
	player.play("shoot")
	yield(player,"finished")
	hability = HABILITY_NONE
	set_timer()

func check_scale(nDir):
	if nDir.x< 0:
		get_node("Sprite").set_scale(Vector2(-1,1))
	else:
		get_node("Sprite").set_scale(Vector2(1,1))
	
func push(target):
	if status == STATUS_HUNTED:
		return
	var nDir = target.get_pos()-get_pos()
	check_scale(nDir)
	set_linear_velocity(nDir.normalized()*force)
	hability = HABILITY_JUMP
	player.play("jump")
	yield(player,"finished")
	hability = HABILITY_NONE
	set_timer()
	

func get_fire():
	if status == STATUS_HUNTED:
		return
	status = STATUS_HUNTED
	sample.play('c')
	
	randomize()
	if randf() > 0.5:
		var wings = wings_packed.instance()
		wings.set_pos(get_global_pos())
		Globals.get("Level").add_child(wings)
	get_node("AnimationPlayer").play("hunted")
	yield(get_node("AnimationPlayer"),'finished')
	queue_free()