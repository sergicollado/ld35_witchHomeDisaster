
extends KinematicBody2D

var speed = Vector2(0,0)
var accel = 6
var gravity = Vector2(0,2)

func _ready():
	set_fixed_process(true)
	set_process_input(true)


func _fixed_process(delta):
	var impulse = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		impulse += Vector2(0,-accel)
	if Input.is_action_pressed("ui_left"):
		get_node("Sprite").set_scale(Vector2(-1,1))
		impulse += Vector2(-accel,0)
	if Input.is_action_pressed("ui_right"):
		get_node("Sprite").set_scale(Vector2(1,1))
		impulse += Vector2(accel,0)
	
	impulse += gravity
	speed += impulse*delta
	var motion = move(speed)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		speed = n.slide(speed)
		move(motion)
