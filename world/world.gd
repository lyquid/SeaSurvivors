class_name World extends Node2D

const MAP_SIZE := Vector2i(200, 200)
const SEED := "1337"
# tilemap
const SOURCE_ID := 0
const GROUND_LAYER := 1
const WATER_LAYER := 0
const TERRAIN_SET_0 := 0
const SAND_TERRAIN := 0
const TERRAIN_SET_1 := 1
const SAND_ON_WATER_TERRAIN := 0

@onready var tile_map := $TileMap
@export var noise: FastNoiseLite
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.set_seed(hash(SEED))
	tile_map.clear()
	generate_map()


func generate_map() -> void:
	var beach_tiles := []
	for y in range(-MAP_SIZE.y * 0.5, MAP_SIZE.y * 0.5):
		for x in range(-MAP_SIZE.x * 0.5, MAP_SIZE.x * 0.5):
			var current_coord := Vector2i(x, y)
			var water_tile_coords := Vector2i(0, 0)
#			# ground
			if noise.get_noise_2d(x, y) > 0.4:
				beach_tiles.push_back(current_coord)
				continue
			# water
			var dice_result := rng.randi_range(1, 100)
			if dice_result < 2:
				water_tile_coords.x = 2
			elif dice_result < 5:
				water_tile_coords.x = 1
			tile_map.set_cell(WATER_LAYER, current_coord, SOURCE_ID, water_tile_coords)
#			# ground
#			if noise.get_noise_2d(x, y) > 0.4:
#				beach_tiles.push_back(current_coord)
	# terrain connect
	tile_map.set_cells_terrain_connect(GROUND_LAYER, beach_tiles, TERRAIN_SET_1, SAND_ON_WATER_TERRAIN)
#	tile_map.set_cells_terrain_connect(GROUND_LAYER, beach_tiles, TERRAIN_SET_0, SAND_TERRAIN)
