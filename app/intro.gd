
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var is_allowed_to_start = false

func _ready():
	OS.set_window_size(config.DEFAULT_RESOLUTION)
	music.play("Intro")
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_accept") and is_allowed_to_start:
		get_tree().change_scene("res://main.scn")

func allow_start():
	is_allowed_to_start = true

