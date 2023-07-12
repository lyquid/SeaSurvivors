extends Enemy

const DEFAULT_GALLEON_ARMOR := 2
const DEFAULT_GALLEON_DAMAGE := 10
const DEFAULT_GALLEON_HEALTH := 50
const DEFAULT_GALLEON_SPEED := 20.0

var boat_pieces_scene := preload("res://effects/boat pieces/boat_pieces.tscn")
var blood_effect_scene := preload("res://effects/blood/blood.tscn")
var galleon_explosion_scene := preload("res://enemies/galleon/galleon_explosion.tscn")
var splash_scene := preload("res://effects/splash/splash.tscn")
var sprite_size: Vector2


func _init() -> void:
	enemy_name = "Boat"
	xp_value = 8
	armor = DEFAULT_GALLEON_ARMOR
	damage = DEFAULT_GALLEON_DAMAGE
	health = DEFAULT_GALLEON_HEALTH
	speed = DEFAULT_GALLEON_SPEED


func _ready() -> void:
	super._ready()
	# this is needed to correctly position the boat explosion particles
	sprite_size = animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_size()
	animated_sprite.play("default")


func die_effects() -> void:
	animated_sprite.visible = false
	# explosion
	var galleon_explosion := galleon_explosion_scene.instantiate()
	galleon_explosion.global_position = global_position - (sprite_size * 0.5)
	world.call_deferred("add_child", galleon_explosion)
#	# boat pieces
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
	splash.scale *= 2.0
	world.call_deferred("add_child", splash)
