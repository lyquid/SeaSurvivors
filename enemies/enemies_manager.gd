class_name EnemiesManager extends Node2D

const DEFAULT_SPAWN_TIME := 10.0
const DEFAULT_GALLEON_SPAWN_TIME := 5.0
const MAX_ENEMIES := 300

@onready var world := get_tree().root.get_node("Main/World")
@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var pickups_manager := get_tree().root.get_node("Main/World/PickupsManager")
@onready var enemy_spawner := $EnemySpawner
@onready var enemy_spawn_location := $EnemySpawner/EnemySpawnLocation
@onready var spawn_timer := $SpawnTimer
@onready var galleon_spawn_timer := $GalleonSpawnTimer
var rng := RandomNumberGenerator.new()
var enemy_pack_scene := preload("res://enemies/enemy_pack.tscn")
# Enemies
var enemies_count := 0
enum Enemies { BOAT, CANOE, GALLEON, count }
var boat_scene := preload("res://enemies/boat/boat.tscn")
var canoe_scene := preload("res://enemies/canoe/canoe.tscn")
var galleon_scene := preload("res://enemies/galleon/galleon.tscn")


func _ready() -> void:
	rng.randomize()
	spawn_random_enemy_pack(20)
	spawn_timer.start(DEFAULT_SPAWN_TIME)
	galleon_spawn_timer.start(DEFAULT_GALLEON_SPAWN_TIME)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.get_button_index() == MOUSE_BUTTON_LEFT \
		and event.is_pressed():
#			spawn_random_enemy(make_canvas_position_local(event.position))
			spawn_enemy(Enemies.GALLEON, make_canvas_position_local(event.position))


func instance_enemy(enemy_type: int) -> Enemy:
	# enemy type
	var enemy: Enemy = null
	match enemy_type:
		Enemies.BOAT:
			enemy = boat_scene.instantiate() as Enemy
		Enemies.CANOE:
			enemy = canoe_scene.instantiate() as Enemy
		Enemies.GALLEON:
			enemy = galleon_scene.instantiate() as Enemy
		_:
			print("Wrong enemy")
	assert(enemy)
	enemy.player = player
	enemy.world = world
	# death & banish signals
	var err := enemy.connect("died", _on_enemy_death)
	assert(not err)
	err = enemy.connect("banished", _on_enemy_banished)
	assert(not err)
	return enemy


func spawn_enemy(enemy_type: int, where := Vector2.INF) -> void:
	var enemy := instance_enemy(enemy_type)
	# location
	if where.is_finite():
		enemy.set_global_position(where)
	else:
		enemy_spawn_location.set_progress_ratio(rng.randi())
		enemy.set_global_position(enemy_spawn_location.global_position + player.global_position)
	# add to world
	world.call_deferred("add_child", enemy)
	enemies_count += 1


func spawn_enemy_pack(enemy_type: int, pack_size: int, where := Vector2.INF, direction := Vector2.INF) -> void:
	var enemy_pack := enemy_pack_scene.instantiate() as EnemyPack
	var radius := 50.0
	# location & direction
	var final_direction: Vector2
	var final_where: Vector2
	if where.is_finite():
		final_direction = direction
		final_where = where
	else:
		enemy_spawn_location.set_progress_ratio(rng.randi())
		final_where = enemy_spawn_location.global_position + player.global_position
		final_direction = (player.global_position - final_where).normalized()
	# create the enemies
	for i in pack_size:
		var radians := 2.0 * PI / pack_size * i
		var spawn_dir := Vector2(cos(radians), sin(radians))
		var spawn_pos := final_where + spawn_dir * radius
		var enemy := instance_enemy(enemy_type)
		# pause AI and set position and direction
		enemy.get_node("AITimer").set_paused(true)
		enemy.set_global_position(spawn_pos)
		enemy.direction = final_direction
		# connect death signal to the pack
		var err := enemy.connect("died_on_a_pack", enemy_pack._on_enemy_death)
		assert(not err)
		# add to pack & increase counters
		enemy_pack.add_child(enemy)
		enemy_pack.size += 1
		enemies_count += 1
	world.call_deferred("add_child", enemy_pack)


func spawn_random_enemy(where := Vector2.INF) -> void:
	spawn_enemy(randi_range(0, Enemies.count - 1), where)


func spawn_random_enemy_pack(pack_size: int) -> void:
	var result := randi_range(0, Enemies.count - 1)
	while result == Enemies.GALLEON:
		result = randi_range(0, Enemies.count - 1)
	spawn_enemy_pack(result, pack_size)


func _on_enemy_death(enemy: Enemy) -> void:
	enemies_count -= 1
	pickups_manager.call_deferred("drop_experience_gem", enemy.global_position, enemy.xp_value)


func _on_enemy_banished() -> void:
	enemies_count -= 1


func _on_spawn_timer_timeout() -> void:
	if enemies_count < MAX_ENEMIES:
		call_deferred("spawn_random_enemy_pack", 20)


func _on_galleon_spawn_timer_timeout():
	spawn_enemy(Enemies.GALLEON)
