extends Weapon

const DEFAULT_CANNON_COOLDOWN := 0.5
const DEFAULT_CANNON_DAMAGE := 50
const DEFAULT_CANNONBALL_SPEED := 250.0
const DEFAULT_CANNONBALL_DISABLE_TIME := 2.0
const DEFAULT_CANNONBALL_PIERCING_POWER := 4

var cannonball_scene := preload("res://weapons/cannon/cannonball.tscn")
var cannonball_speed := DEFAULT_CANNONBALL_SPEED
var cannonball_piercing_power := DEFAULT_CANNONBALL_PIERCING_POWER


func _ready():
	damage = DEFAULT_CANNON_DAMAGE
	cooldown = DEFAULT_CANNON_COOLDOWN
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()


func _on_cooldown_timer_timeout():
	fire()


func fire():
	var cannonball := cannonball_scene.instantiate()
	cannonball.damage = damage
	cannonball.piercing_power = cannonball_piercing_power
	cannonball.disable_time = DEFAULT_CANNONBALL_DISABLE_TIME
	cannonball.speed = cannonball_speed
	cannonball.global_position = player.global_position
	if player.facing_left:
		cannonball.direction = Vector2(-1.0, 0.0)
	else:
		cannonball.direction = Vector2(1.0, 0.0)
	world.call_deferred("add_child", cannonball)
