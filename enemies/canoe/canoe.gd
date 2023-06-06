extends Enemy

const DEFAULT_CANOE_ARMOR := 0
const DEFAULT_CANOE_DAMAGE := 5
const DEFAULT_CANOE_HEALTH := 1
const DEFAULT_CANOE_SPEED_RANGE := Vector2(35.0, 45.0)

var blood_effect_scene := preload("res://effects/blood/blood.tscn")
var boat_pieces_scene := preload("res://effects/boat pieces/boat_pieces.tscn")
var canoe_explosion_scene := preload("res://enemies/canoe/canoe_explosion.tscn")
var splash_scene := preload("res://effects/splash/splash.tscn")
var sprite_size: Vector2


func _ready() -> void:
	enemy_name = "Canoe"
	xp_value = 1
	armor = DEFAULT_CANOE_ARMOR
	damage = DEFAULT_CANOE_DAMAGE
	health = DEFAULT_CANOE_HEALTH
	speed = randf_range(DEFAULT_CANOE_SPEED_RANGE.x, DEFAULT_CANOE_SPEED_RANGE.y)
	# this is needed to correctly position the boat explosion particles
	sprite_size = animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_size()
	animated_sprite.play("default")


func die_effects() -> void:
	animated_sprite.visible = false
	# explosion
	var canoe_explosion := canoe_explosion_scene.instantiate()
	canoe_explosion.global_position = global_position - (sprite_size * 0.5)
	get_parent().call_deferred("add_child", canoe_explosion)
	# boat pieces
	var pieces := boat_pieces_scene.instantiate()
	pieces.global_position = global_position
	get_parent().call_deferred("add_child", pieces)
	# blood
	var blood_effect := blood_effect_scene.instantiate()
	blood_effect.global_position = global_position
	get_parent().call_deferred("add_child", blood_effect)
	# splash
	var splash := splash_scene.instantiate()
	splash.global_position = global_position
	splash.position.y -= 6.0
	get_parent().call_deferred("add_child", splash)
