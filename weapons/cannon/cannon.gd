extends Weapon

const DEFAULT_CANNON_COOLDOWN := 1.0
const DEFAULT_CANNON_DAMAGE := 10
const DEFAULT_CANNON_DISABLE_TIME := 2.0
const DEFAULT_CANNON_PIERCING_POWER := 4
const DEFAULT_CANNON_ROWS := 5 # max 8!
const DEFAULT_CANNON_ROW_COOLDOWN := 0.1
const DEFAULT_CANNON_SPEED := 250.0

var rows := DEFAULT_CANNON_ROWS
var rows_positions: Array
var row_cooldown := DEFAULT_CANNON_ROW_COOLDOWN
var current_row := 1
var cannonball_scene := preload("res://weapons/cannon/cannonball.tscn")


func _ready() -> void:
	init_rows_positions()
	damage = DEFAULT_CANNON_DAMAGE
	piercing_power = DEFAULT_CANNON_PIERCING_POWER
	projectile_disable_time = DEFAULT_CANNON_DISABLE_TIME
	speed = DEFAULT_CANNON_SPEED
	cooldown = DEFAULT_CANNON_COOLDOWN
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()


func fire() -> void:
	var cannonball_up := init_cannonball()
	var cannonball_down := init_cannonball()
	cannonball_up.direction = Vector2(0.0, -1.0)
	cannonball_down.direction = Vector2(0.0, 1.0)
	world.call_deferred("add_child", cannonball_up)
	world.call_deferred("add_child", cannonball_down)
	if current_row == rows:
		current_row = 1
		cooldown_timer.wait_time = cooldown
		cooldown_timer.start()
	else:
		current_row += 1
		cooldown_timer.wait_time = row_cooldown
		cooldown_timer.start()


func init_cannonball() -> Projectile:
	var cannonball := cannonball_scene.instantiate()
	cannonball.damage = damage
	cannonball.piercing_power = piercing_power
	cannonball.disable_time = projectile_disable_time
	cannonball.speed = speed
	cannonball.global_position = to_global(Vector2(rows_positions[current_row - 1], 0.0)) 
	return cannonball


func init_rows_positions() -> void:
	rows_positions.resize(rows)
	match rows:
		1:
			rows_positions[0] = 0.0
		2: 
			rows_positions[0] = 15.0
			rows_positions[1] = -15.0
		3: 
			rows_positions[0] = 15.0
			rows_positions[1] = 0.0
			rows_positions[2] = -15.0
		4: 
			rows_positions[0] = 15.0
			rows_positions[1] = 5.0
			rows_positions[2] = -5.0
			rows_positions[3] = -15.0
		5: 
			rows_positions[0] = 15.0
			rows_positions[1] = 7.5
			rows_positions[2] = 0.0
			rows_positions[3] = -7.5
			rows_positions[4] = -15.0
		6: 
			rows_positions[0] = 15.0
			rows_positions[1] = 10.0
			rows_positions[2] = 5.0
			rows_positions[3] = -5.0
			rows_positions[4] = -10.0
			rows_positions[5] = -15.0
		7: 
			rows_positions[0] = 15.0
			rows_positions[1] = 10.0
			rows_positions[2] = 5.0
			rows_positions[3] = 0.0
			rows_positions[4] = -5.0
			rows_positions[5] = -10.0
			rows_positions[6] = -15.0
		8: 
			rows_positions[0] = 15.0
			rows_positions[1] = 11.25
			rows_positions[2] = 7.5
			rows_positions[3] = 3.75
			rows_positions[4] = -3.75
			rows_positions[5] = -7.5
			rows_positions[6] = -11.25
			rows_positions[7] = -15.0
