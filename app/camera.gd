
extends Camera2D

onready var tween = get_node("Tween")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func go_to(from, pos):
	tween.interpolate_property(self,"transform/pos", from, pos,0.5,tween.TRANS_EXPO, tween.EASE_OUT)
	tween.start()
