class_name Enemy extends RigidBody2D

signal died

const DEFAULT_DAMAGE_LABEL_TIME := 0.3

@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var animated_sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer
@onready var damage_label := $DamageLabel
@onready var damage_label_timer := $DamageLabel/DamageLabelTimer
@onready var death_timer := $DeathTimer
var armor: int
var damage: int
var direction: Vector2
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
	set_process(false)
	set_physics_process(false)
	set_collision_layer_value(3, false)
	$AITimer.set_paused(true)
	die_effects()
	death_timer.set_wait_time(DEFAULT_DAMAGE_LABEL_TIME)
	death_timer.start()


func die_effects() -> void:
	animated_sprite.set_visible(false)


func hit(damage_in: int) -> void:
	health -= damage_in
	damage_label.set_text(str(damage_in))
	damage_label.set_visible(true)
	damage_label_timer.set_wait_time(DEFAULT_DAMAGE_LABEL_TIME)
	damage_label_timer.start()
	if health <= 0:
		die()
	else:
		animation_player.play("hit")


func _on_ai_timer_timeout() -> void:
	direction = (player.position - position).normalized()


func _on_death_timer_timeout() -> void:
	emit_signal("died", self)
	queue_free()


func _on_damage_label_timer_timeout() -> void:
	damage_label.set_visible(false)
