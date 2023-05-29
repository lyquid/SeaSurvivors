class_name World extends Node2D

const MAP_SIZE := Vector2i(200, 200)

@onready var tile_map := $TileMap
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	tile_map.clear()
	generate_map()


func generate_map() -> void:
	for y in range(-MAP_SIZE.y * 0.5, MAP_SIZE.y * 0.5):
		for x in range(-MAP_SIZE.x * 0.5, MAP_SIZE.x * 0.5):
			var tile_coords := Vector2i()
			var dice_result := rng.randi_range(1, 100)
			if dice_result < 90:
				tile_coords.x = 0
			elif dice_result < 95:
				tile_coords.x = 1
			else:
				tile_coords.x = 2
			tile_map.set_cell(0, Vector2i(x, y), 0, tile_coords)
