class_name Enemy extends RigidBody2D

signal died

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
	collision_shape.set_deferred("disabled", true)
	animated_sprite.modulate = Color.RED
	death_timer.wait_time = animation_player.get_animation("death").length
	death_timer.start()
	animation_player.play("death")


func hit(damage_in: int):
	if not dying:
		health -= damage_in
		damage_label.text = str(damage_in)
		damage_label.visible = true
		damage_label_timer.start()
		if health <= 0:
			die()
		else:
			animation_player.play("hit")


func _on_ai_timer_timeout():
	direction = (player.position - position).normalized()


func _on_death_timer_timeout():
	emit_signal("died")
	queue_free()


func _on_damage_label_timer_timeout():
	damage_label.visible = false
