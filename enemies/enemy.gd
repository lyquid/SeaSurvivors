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


func _integrate_forces(state: PhysicsDirectBodyState2D):
	state.linear_velocity = direction * speed


func _process(_delta: float):
	if direction.x > 0.0:
		animated_sprite.flip_h = false
	elif direction.x < 0.0:
		animated_sprite.flip_h = true


func die():
	dying = true
	direction = Vector2.ZERO
	animated_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	death_timer.wait_time = DEFAULT_DAMAGE_LABEL_TIME
	death_timer.start()


func hit(damage_in: int):
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


func _on_ai_timer_timeout():
	if not dying:
		direction = (player.position - position).normalized()


func _on_death_timer_timeout():
	emit_signal("died")
	queue_free()


func _on_damage_label_timer_timeout():
	damage_label.visible = false
