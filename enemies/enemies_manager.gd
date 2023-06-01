class_name EnemiesManager extends Node

const DEFAULT_SPAWN_TIME := 0.01
const MAX_ENEMIES := 300

@onready var world := get_tree().root.get_node("Main/World")
@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var enemy_spawner := $EnemySpawner
@onready var enemy_spawn_location := $EnemySpawner/EnemySpawnLocation
@onready var spawn_timer := $SpawnTimer
var rng := RandomNumberGenerator.new()
var xp_scene := preload("res://pickups/experience/experience_gem.tscn")
# Enemies
var enemies_count := 0
enum { BOAT, CANOE }
var boat_scene := preload("res://enemies/boat/boat.tscn")
var canoe_scene := preload("res://enemies/canoe/canoe.tscn")


func _ready() -> void:
	rng.randomize()
	spawn_timer.wait_time = DEFAULT_SPAWN_TIME
	spawn_timer.start()


func instance_enemy(enemy_type) -> void:
	var enemy: Enemy = null
	match enemy_type:
		BOAT:
			enemy = boat_scene.instantiate()
		CANOE:
			enemy = canoe_scene.instantiate()
		_:
			print("Wrong enemy")
	assert(enemy)
	world.call_deferred("add_child", enemy)
	var err := enemy.connect("died", _on_enemy_death)
	assert(!err)
	enemy_spawn_location.progress_ratio = rng.randi()
	enemy.position = enemy_spawn_location.global_position + player.global_position

	enemies_count += 1


func spawn_enemy() -> void:
	var dice := randi_range(1, 100)
	if dice < 50:
		instance_enemy(BOAT)
	else:
		instance_enemy(CANOE)


#func spawn_enemy(enemy: Enemy):
#	# Check if it's a valid position
#	var valid_position := false
#	while not valid_position:
#		enemy_spawn_location.offset = randi()
##		valid_position = test_position(enemy_spawn_location.position + player.position)
#		valid_position = true
#	enemy.position = enemy_spawn_location.position + player.position


func drop_experience_gem(where: Vector2, xp_value: int) -> void:
	var xp_gem := xp_scene.instantiate()
	xp_gem.player = player
	xp_gem.value = xp_value
	xp_gem.global_position = where
	get_parent().call_deferred("add_child", xp_gem)


func _on_enemy_death(enemy: Enemy) -> void:
	enemies_count -= 1
	drop_experience_gem(enemy.global_position, enemy.xp_value)


func _on_spawn_timer_timeout() -> void:
	if enemies_count < MAX_ENEMIES:
		spawn_enemy()
