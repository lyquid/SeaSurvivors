extends Weapon

const DEFAULT_BALLISTA_BURST_COOLDOWN := 0.05
const DEFAULT_BALLISTA_BURST_SIZE := 5
const DEFAULT_BALLISTA_COOLDOWN := 1.0
const DEFAULT_BALLISTA_DAMAGE := 8
const DEFAULT_BALLISTA_DISABLE_TIME := 1.5
const DEFAULT_BALLISTA_PIERCING_POWER := 2
const DEFAULT_BALLISTA_SPEED := 300.0

var bolt_scene := preload("res://weapons/ballista/bolt.tscn")
var burst_size := DEFAULT_BALLISTA_BURST_SIZE
var current_burst := 1
var fire_up := true


func _ready() -> void:
	damage = DEFAULT_BALLISTA_DAMAGE
	piercing_power = DEFAULT_BALLISTA_PIERCING_POWER
	projectile_disable_time = DEFAULT_BALLISTA_DISABLE_TIME
	speed = DEFAULT_BALLISTA_SPEED
	cooldown = DEFAULT_BALLISTA_COOLDOWN
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()


func init_bolt() -> Projectile:
	var bolt := bolt_scene.instantiate()
	bolt.damage = damage
	bolt.piercing_power = piercing_power
	bolt.disable_time = projectile_disable_time
	bolt.speed = speed
	bolt.global_position = player.global_position
	if player.facing_left:
		bolt.direction = Vector2(-1.0, 0.0)
		bolt.position.x -= 30.0
		bolt.get_node("AnimatedSprite2D").flip_h = true
	else:
		bolt.direction = Vector2(1.0, 0.0)
		bolt.position.x += 30.0
	if fire_up:
		bolt.position.y -= 5
	else:
		bolt.position.y += 5
	fire_up = not fire_up
	return bolt


func fire() -> void:
	world.call_deferred("add_child", init_bolt())
	if current_burst < burst_size:
		cooldown_timer.wait_time = DEFAULT_BALLISTA_BURST_COOLDOWN
		current_burst += 1
	else:
		cooldown_timer.wait_time = cooldown
		current_burst = 1
	cooldown_timer.start()