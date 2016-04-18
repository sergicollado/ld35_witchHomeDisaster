
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
export var type = "fly_wings"
var collected = false

func _ready():
	get_node("Area2D").connect("body_enter",self, "_collected")

func _collected(body):
	if body.get_name()!= "Witch" or collected:
		return
	if global.recipe[type] > 0:
		global.recipe[type] -= 1
	sample.play("item_b")	
	get_node("AnimationPlayer").play("collected")
	yield(get_node("AnimationPlayer"), "finished")
	queue_free()
