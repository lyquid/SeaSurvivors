extends Weapon

const DEFAULT_BALLISTA_BURST_COOLDOWN := 0.05
const DEFAULT_BALLISTA_BURST_SIZE := 5
const DEFAULT_BALLISTA_COOLDOWN := 1.0
const DEFAULT_BALLISTA_DAMAGE := 8
const DEFAULT_BALLISTA_DISABLE_TIME := 1.5
const DEFAULT_BALLISTA_PIERCING_POWER := 2
const DEFAULT_BALLISTA_SPEED := 300.0
const DEFAULT_BOLT_OFFSETS := [-4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0]

var bolt_scene := preload("res://weapons/ballista/bolt.tscn")
var burst_size := DEFAULT_BALLISTA_BURST_SIZE
var current_burst := 1
var fire_switch := true
var bolt_offset := 5.0
var bolt_offsets := DEFAULT_BOLT_OFFSETS.duplicate()


func _ready() -> void:
	damage = DEFAULT_BALLISTA_DAMAGE
	piercing_power = DEFAULT_BALLISTA_PIERCING_POWER
	projectile_disable_time = DEFAULT_BALLISTA_DISABLE_TIME
	speed = DEFAULT_BALLISTA_SPEED
	# bolts' offset
	bolt_offsets.shuffle()
	# cooldown
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
	bolt.direction = player.last_direction
	bolt.rotation = bolt.direction.angle()
	if fire_switch:
		if is_zero_approx(bolt.direction.x):
			bolt.position.x -= bolt_offset + get_random_offset()
		else:
			bolt.position.y -= bolt_offset + get_random_offset()
	else:
		if is_zero_approx(bolt.direction.x):
			bolt.position.x += bolt_offset + get_random_offset()
		else:
			bolt.position.y += bolt_offset + get_random_offset()
	fire_switch = not fire_switch
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


func get_random_offset() -> float:
	if bolt_offsets.is_empty():
		bolt_offsets = DEFAULT_BOLT_OFFSETS.duplicate()
		bolt_offsets.shuffle()
	return bolt_offsets.pop_front()
