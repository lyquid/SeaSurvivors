class_name Enemy extends RigidBody2D

signal died

const DEFAULT_DAMAGE_LABEL_TIME := 0.3

@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var animated_sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer
@onready var collision_shape := $CollisionShape2D
@onready var damage_label := $DamageLabel
@onready var damage_label_timer := $DamageLabel/DamageLabelTimer
@onready var death_timer := $DeathTimer
var armor: int
var damage: int
var direction: Vector2
var dying := false
var enemy_name: String
var health: int
var speed: float
var xp_value: int


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = direction * speed


func _process(_delta: float) -> void:
	if direction.x > 0.0:
		animated_sprite.flip_h = false
	elif direction.x < 0.0:
		animated_sprite.flip_h = true


func die() -> void:
	dying = true
	direction = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	die_effects()
	death_timer.wait_time = DEFAULT_DAMAGE_LABEL_TIME
	death_timer.start()


func die_effects() -> void:
	animated_sprite.visible = false


func hit(damage_in: int) -> void:
	if not dying:
		health -= damage_in
		damage_label.text = str(damage_in)
		damage_label.visible = true
		damage_label_timer.wait_time = DEFAULT_DAMAGE_LABEL_TIME
		damage_label_timer.start()
		if health <= 0:
			die()
		else:
			animation_player.play("hit")


func _on_ai_timer_timeout() -> void:
	if not dying:
		direction = (player.position - position).normalized()


func _on_death_timer_timeout() -> void:
	emit_signal("died", self)
	queue_free()


func _on_damage_label_timer_timeout() -> void:
	damage_label.visible = false
