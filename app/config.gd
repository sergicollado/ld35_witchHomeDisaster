extends Node

var DEFAULT_RESOLUTION = Vector2(800,800)
var LEVEL_GRID = Vector2(5,3)
var TILE_SIZE = 32
var ROOM_SIZE = 16
var HOUSE_SIZE = Vector2(int(TILE_SIZE*ROOM_SIZE*LEVEL_GRID.x),int(TILE_SIZE*ROOM_SIZE*LEVEL_GRID.y))

var TILE_WALL = 4
var TILE_WALL_2 = 6
var TILE_WALL_3 = 7

var TILE_FLOOR = 0
var TILE_DOOR = 5
var MAX_DOOR_SIZE = 5

var RECIPE_LEGS = '5'
var RECIPE_WINGS = '8'