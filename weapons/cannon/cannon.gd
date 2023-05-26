extends Weapon

const DEFAULT_CANNON_COOLDOWN := 2.0
const DEFAULT_CANNON_ROW_COOLDOWN := 0.3
const DEFAULT_CANNON_DAMAGE := 10
const DEFAULT_CANNON_ROWS := 8
const DEFAULT_CANNONBALL_SPEED := 250.0
const DEFAULT_CANNONBALL_DISABLE_TIME := 2.0
const DEFAULT_CANNONBALL_PIERCING_POWER := 4

var cannon_rows := DEFAULT_CANNON_ROWS
var cannon_rows_positions: Array
var current_row := 1
var cannonball_row_cooldown := DEFAULT_CANNON_ROW_COOLDOWN
var cannonball_scene := preload("res://weapons/cannon/cannonball.tscn")
var cannonball_speed := DEFAULT_CANNONBALL_SPEED
var cannonball_piercing_power := DEFAULT_CANNONBALL_PIERCING_POWER


func _ready() -> void:
	init_rows_positions()
	damage = DEFAULT_CANNON_DAMAGE
	cooldown = DEFAULT_CANNON_COOLDOWN
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	fire()


func fire() -> void:
	var cannonball_up := init_cannonball()
	var cannonball_down := init_cannonball()
	cannonball_up.direction = Vector2(0.0, -1.0)
	cannonball_down.direction = Vector2(0.0, 1.0)
	world.call_deferred("add_child", cannonball_up)
	world.call_deferred("add_child", cannonball_down)
	if current_row == cannon_rows:
		current_row = 1
		cooldown_timer.wait_time = cooldown
		cooldown_timer.start()
	else:
		current_row += 1
		cooldown_timer.wait_time = cannonball_row_cooldown
		cooldown_timer.start()


func init_cannonball() -> Projectile:
	var cannonball := cannonball_scene.instantiate()
	cannonball.damage = damage
	cannonball.piercing_power = cannonball_piercing_power
	cannonball.disable_time = DEFAULT_CANNONBALL_DISABLE_TIME
	cannonball.speed = cannonball_speed
	cannonball.global_position = to_global(Vector2(cannon_rows_positions[current_row - 1], 0.0)) 
	return cannonball


func init_rows_positions() -> void:
	cannon_rows_positions.resize(cannon_rows)
	match cannon_rows:
		1:
			cannon_rows_positions[0] = 0.0
		2: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = -15.0
		3: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 0.0
			cannon_rows_positions[2] = -15.0
		4: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 5.0
			cannon_rows_positions[2] = -5.0
			cannon_rows_positions[3] = -15.0
		5: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 7.5
			cannon_rows_positions[2] = 0.0
			cannon_rows_positions[3] = -7.5
			cannon_rows_positions[4] = -15.0
		6: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 10.0
			cannon_rows_positions[2] = 5.0
			cannon_rows_positions[3] = -5.0
			cannon_rows_positions[4] = -10.0
			cannon_rows_positions[5] = -15.0
		7: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 10.0
			cannon_rows_positions[2] = 5.0
			cannon_rows_positions[3] = 0.0
			cannon_rows_positions[4] = -5.0
			cannon_rows_positions[5] = -10.0
			cannon_rows_positions[6] = -15.0
		8: 
			cannon_rows_positions[0] = 15.0
			cannon_rows_positions[1] = 11.25
			cannon_rows_positions[2] = 7.5
			cannon_rows_positions[3] = 3.75
			cannon_rows_positions[4] = -3.75
			cannon_rows_positions[5] = -7.5
			cannon_rows_positions[6] = -11.25
			cannon_rows_positions[7] = -15.0
