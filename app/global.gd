
extends Node
var config_packed = preload("res://config.gd")

var config = config_packed.new()
var recipe = {
	"frog_legs": int(config.RECIPE_LEGS),
	"fly_wings": int(config.RECIPE_WINGS)
}

func restart():
	recipe.frog_legs = int(config.RECIPE_LEGS)
	recipe.fly_wings = int(config.RECIPE_WINGS)