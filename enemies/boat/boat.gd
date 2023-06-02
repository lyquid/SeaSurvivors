extends Enemy

const DEFAULT_BOAT_ARMOR := 0
const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 1
const DEFAULT_BOAT_SPEED_RANGE := Vector2(30.0, 40.0)

var boat_explosion_scene := preload("res://enemies/boat/boat_explosion.tscn")
var blood_effect_scene := preload("res://effects/blood/blood.tscn")
var splash_scene := preload("res://effects/splash/splash.tscn")
var sprite_size: Vector2


func _ready() -> void:
	enemy_name = "Boat"
	xp_value = 1
	armor = DEFAULT_BOAT_ARMOR
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = randf_range(DEFAULT_BOAT_SPEED_RANGE.x, DEFAULT_BOAT_SPEED_RANGE.y)
	# this is needed to correctly position the boat explosion particles
	sprite_size = animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_size()
	animated_sprite.play("default")


func die_effects() -> void:
	animated_sprite.visible = false
	# explosion
	var boat_explosion := boat_explosion_scene.instantiate()
	boat_explosion.global_position = global_position - (sprite_size * 0.5)
	get_parent().call_deferred("add_child", boat_explosion)
	# blood
	var blood_effect := blood_effect_scene.instantiate()
	blood_effect.global_position = global_position
	get_parent().call_deferred("add_child", blood_effect)
	# splash
	var splash := splash_scene.instantiate()
	splash.global_position = global_position
	splash.position.y -= 6.0
	get_parent().call_deferred("add_child", splash)
