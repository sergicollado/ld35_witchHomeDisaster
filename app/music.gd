
extends Node2D

func play(song):
	print(get_children())
	var songs =["Intro","Game","Moon"]
	for el in songs:
		if el == song and not get_node(el).is_playing():
			get_node(el).play()
		elif get_node(el).is_playing():
			get_node(el).stop()
