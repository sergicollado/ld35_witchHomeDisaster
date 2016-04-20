
extends KinematicBody2D

var speed = Vector2(0,0)
var accel = 6
var gravity = Vector2(0,2)
var delta_pressed = 0
onready var gun = load("res://props/gun.scn")
onready var shoot_pos = get_node("Position2D")
onready var progress = get_node("Sprite/TextureProgress")
onready var area = get_node("Area2D")
onready var player = get_node("AnimationPlayer")

var INIT_SHOOT_X = 18
var dir_shot = Vector2(1,0)

var STATUS_NORMAL = 0
var STATUS_DEAD = 1
var status = STATUS_NORMAL

func _ready():
	area.connect("body_enter", self,"_collision")
	set_fixed_process(true)
	set_process_input(true)

func _collision(body):
	if body.is_in_group("mortal") and status != STATUS_DEAD:
		get_fire()
	
func get_fire():
	if  status != STATUS_DEAD:
		status = STATUS_DEAD
		player.play("dead")
		sample.play('b')
		set_fixed_process(false)
		set_process_input(true)
		

func _input(ev):
	if ev.is_action_released("ui_accept"):
		shoot()

func shoot():
	sample.play('a_low')
	var new_gun = gun.instance()
	new_gun.dir = dir_shot
	new_gun.set_pos(shoot_pos.get_global_pos())
	var scale = lerp(0,1,delta_pressed)
	scale = min(scale,2)
	new_gun.set_scale(Vector2(scale,scale))
	Globals.get("Level").add_child(new_gun)
	delta_pressed = 0

func _fixed_process(delta):
	progress.set_val(delta_pressed)
	var impulse = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		impulse += Vector2(0,-accel)
		
	if Input.is_action_pressed("ui_left"):
		get_node("Sprite").set_scale(Vector2(-1,1))
		shoot_pos.set_pos(Vector2(-INIT_SHOOT_X, 0))
		dir_shot = Vector2(-1,0)
		impulse += Vector2(-accel,0)

		
	if Input.is_action_pressed("ui_right"):
		get_node("Sprite").set_scale(Vector2(1,1))
		shoot_pos.set_pos(Vector2(INIT_SHOOT_X, 0))
		dir_shot = Vector2(1,0)
		impulse += Vector2(accel,0)
		
	if Input.is_action_pressed("ui_accept"):
		delta_pressed += delta

		
	impulse += gravity
	speed += impulse*delta
	var motion = move(speed)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		speed = n.slide(speed)
		move(motion)
