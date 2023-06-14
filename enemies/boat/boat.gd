extends Enemy

const DEFAULT_BOAT_ARMOR := 0
const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 1
const DEFAULT_BOAT_SPEED := 30.0

var boat_explosion_scene := preload("res://enemies/boat/boat_explosion.tscn")
var boat_pieces_scene := preload("res://effects/boat pieces/boat_pieces.tscn")
var blood_effect_scene := preload("res://effects/blood/blood.tscn")
var splash_scene := preload("res://effects/splash/splash.tscn")
var sprite_size: Vector2


func _init() -> void:
	enemy_name = "Boat"
	xp_value = 1
	armor = DEFAULT_BOAT_ARMOR
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = DEFAULT_BOAT_SPEED
	

func _ready() -> void:
	super._ready()
	# this is needed to correctly position the boat explosion particles
	sprite_size = animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_size()
	animated_sprite.play("default")


func die_effects() -> void:
	animated_sprite.visible = false
	# explosion
	var boat_explosion := boat_explosion_scene.instantiate()
	boat_explosion.global_position = global_position - (sprite_size * 0.5)
	world.call_deferred("add_child", boat_explosion)
	# boat pieces
	var pieces := boat_pieces_scene.instantiate()
	pieces.global_position = global_position
	world.call_deferred("add_child", pieces)
	# blood
	var blood_effect := blood_effect_scene.instantiate()
	blood_effect.global_position = global_position
	world.call_deferred("add_child", blood_effect)
	# splash
	var splash := splash_scene.instantiate()
	splash.global_position = global_position
	splash.position.y -= 6.0
	world.call_deferred("add_child", splash)
