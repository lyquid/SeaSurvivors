extends Enemy

const DEFAULT_BOAT_ARMOR := 0
const DEFAULT_BOAT_DAMAGE := 5
const DEFAULT_BOAT_HEALTH := 1
const DEFAULT_BOAT_SPEED_RANGE := Vector2(30.0, 40.0)

@onready var blood_effect_scene := preload("res://effects/blood/blood.tscn")


func _ready() -> void:
	enemy_name = "Boat"
	armor = DEFAULT_BOAT_ARMOR
	damage = DEFAULT_BOAT_DAMAGE
	health = DEFAULT_BOAT_HEALTH
	speed = randf_range(DEFAULT_BOAT_SPEED_RANGE.x, DEFAULT_BOAT_SPEED_RANGE.y)
	animated_sprite.play("default")


func die_effects() -> void:
	animated_sprite.visible = false
	var blood_effect := blood_effect_scene.instantiate()
	blood_effect.global_position = global_position
	get_parent().call_deferred("add_child", blood_effect)
