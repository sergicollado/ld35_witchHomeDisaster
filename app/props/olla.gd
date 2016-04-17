
extends StaticBody2D

onready var area = get_node("Area2D")
onready var player = get_node("AnimationPlayer")
onready var timer = get_node("Timer")

func _ready():
	area.connect("body_enter", self, "any_near")
	
func any_near(body):
	if body.get_name() == "Witch":
		var level = Globals.get("Level")
		player.play("cooking")
		if level.is_recipe_complete():
			level.complete_game()
		else:
			level.recipe_incomplete()
			timer.start()
			yield(timer, 'timeout')
			player.stop()
			get_node("flames").hide()
		


