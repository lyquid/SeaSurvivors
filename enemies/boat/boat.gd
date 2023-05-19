extends Enemy

const DEFAULT_BOAT_ARMOR := 0
const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 1
const DEFAULT_BOAT_SPEED_RANGE := Vector2(30.0, 40.0)


func _ready():
	enemy_name = "Boat"
	armor = DEFAULT_BOAT_ARMOR
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = randf_range(DEFAULT_BOAT_SPEED_RANGE.x, DEFAULT_BOAT_SPEED_RANGE.y)
	animated_sprite.play("default")
