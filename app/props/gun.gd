
extends Area2D

var dir= Vector2(0,0)
var speed = 200
var STATUS_NORMAL = 0
var STATUS_COLLISION = 1
var status = STATUS_NORMAL 
var player_target = false

func _ready():
	set_process(true)
	connect("body_enter", self,"_collision")
	if dir.x < 0:
		get_node("Sprite").set_flip_h(true)
		get_node("Light2D").set_scale(Vector2(-1,1))

func _process(delta):
	if status == STATUS_COLLISION:
		set_process(false)
		return
		
	set_pos(get_pos()+(dir*speed*delta))

func _collision(body):
	if status == STATUS_COLLISION or (body.get_name() == "Witch" and !player_target):
		return
	if body.has_method("get_fire"):
		body.get_fire()
	status= STATUS_COLLISION
	get_node("AnimationPlayer").play("collision")
	yield(get_node("AnimationPlayer"), "finished")
	queue_free()
