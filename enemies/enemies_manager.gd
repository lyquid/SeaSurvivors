class_name EnemiesManager extends Node

const DEFAULT_SPAWN_TIME := 0.05
const MAX_ENEMIES := 300

@onready var world := get_tree().root.get_node("Main/World")
@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var enemy_spawner := $EnemySpawner
@onready var enemy_spawn_location := $EnemySpawner/EnemySpawnLocation
@onready var spawn_timer := $SpawnTimer
var rng := RandomNumberGenerator.new()
# Enemies
var enemies_count := 0
enum { BOAT }
var boat_scene := preload("res://enemies/boat/boat.tscn")


func _ready():
	rng.randomize()
	spawn_timer.wait_time = DEFAULT_SPAWN_TIME
	spawn_timer.start()


func instance_enemy(enemy_type):
	var enemy: Enemy = null
	match enemy_type:
		BOAT:
			enemy = boat_scene.instantiate()
		_:
			print("Wrong enemy")
	assert(enemy)
	world.call_deferred("add_child", enemy)
	var err := enemy.connect("died", _on_enemy_death)
	assert(!err)
	enemy_spawn_location.progress_ratio = rng.randi()
	enemy.position = enemy_spawn_location.global_position + player.global_position

	enemies_count += 1


func spawn_enemy():
	instance_enemy(BOAT)


#func spawn_enemy(enemy: Enemy):
#	# Check if it's a valid position
#	var valid_position := false
#	while not valid_position:
#		enemy_spawn_location.offset = randi()
##		valid_position = test_position(enemy_spawn_location.position + player.position)
#		valid_position = true
#	enemy.position = enemy_spawn_location.position + player.position


func _on_enemy_death():
	enemies_count -= 1


func _on_spawn_timer_timeout():
	if enemies_count < MAX_ENEMIES:
		spawn_enemy()
