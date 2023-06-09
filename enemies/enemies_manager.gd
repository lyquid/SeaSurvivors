class_name EnemiesManager extends Node2D

const DEFAULT_SPAWN_TIME := 0.1
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
enum Enemies { BOAT, CANOE, count }
var boat_scene := preload("res://enemies/boat/boat.tscn")
var canoe_scene := preload("res://enemies/canoe/canoe.tscn")


func _ready() -> void:
	rng.randomize()
	spawn_timer.set_wait_time(DEFAULT_SPAWN_TIME)
	spawn_timer.start()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.get_button_index() == MOUSE_BUTTON_LEFT \
		and event.is_pressed():
			spawn_random_enemy(make_canvas_position_local(event.position))


func instance_enemy(enemy_type: int, where := Vector2.INF) -> void:
	var enemy: Enemy = null
	match enemy_type:
		Enemies.BOAT:
			enemy = boat_scene.instantiate()
		Enemies.CANOE:
			enemy = canoe_scene.instantiate()
		_:
			print("Wrong enemy")
	assert(enemy)
	world.call_deferred("add_child", enemy)
	var err := enemy.connect("died", _on_enemy_death)
	assert(!err)
	# location
	if where.is_finite():
		enemy.set_global_position(where)
	else:
		enemy_spawn_location.set_progress_ratio(rng.randi())
		enemy.set_global_position(enemy_spawn_location.global_position + player.global_position)

	enemies_count += 1


func spawn_enemy(enemy_type: int, where := Vector2.INF) -> void:
	instance_enemy(enemy_type, where)


func spawn_random_enemy(where := Vector2.INF) -> void:
	instance_enemy(randi_range(0, Enemies.count - 1), where)


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
		spawn_random_enemy()
