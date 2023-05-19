extends Enemy

const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 100
const DEFAULT_BOAT_SPEED := 40.0


func _ready():
	enemy_name = "Boat"
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = DEFAULT_BOAT_SPEED
	animated_sprite.play("default")
