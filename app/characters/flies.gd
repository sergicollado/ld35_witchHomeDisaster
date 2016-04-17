
extends RigidBody2D

var STATUS_NORMAL = 0
var STATUS_HUNTED = 1
var status = STATUS_NORMAL

onready var wings_packed = load("res://props/wings.tscn")
onready var timer = get_node("Timer")
var force = 200

func _ready():
	add_to_group("mortal")
	get_node("VisibilityNotifier2D").connect("enter_screen",self, "set_timer")


func set_timer():
	timer.start()
	yield(timer, 'timeout')
	push()

func push():
	if status == STATUS_HUNTED:
		return
	randomize()
	var rot = deg2rad(rand_range(0,360))
	set_rot(deg2rad(rot))
	var nDir = Vector2(sin(rot), cos(rot)).normalized()
	set_linear_velocity(nDir*force)
	set_timer()
	

func get_fire():
	if status == STATUS_HUNTED:
		return
	status = STATUS_HUNTED
	var wings = wings_packed.instance()
	wings.set_pos(get_global_pos())
	Globals.get("Level").add_child(wings)
	get_node("AnimationPlayer").play("hunted")
	yield(get_node("AnimationPlayer"),'finished')
	queue_free()