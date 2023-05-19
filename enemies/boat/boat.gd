extends Enemy

const DEFAULT_BOAT_ARMOR := 0
const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 1
const DEFAULT_BOAT_SPEED := 40.0


func _ready():
	enemy_name = "Boat"
	armor = DEFAULT_BOAT_ARMOR
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = DEFAULT_BOAT_SPEED
	animated_sprite.play("default")
