class_name Enemy extends CharacterBody2D

signal banished
signal died
signal died_on_a_pack

const DEFAULT_BANISH_TIME := 10.0
const DEFAULT_DAMAGE_LABEL_TIME := 0.3

@onready var animated_sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer
@onready var banish_timer := $VisibleOnScreenNotifier2D/BanishTimer
@onready var damage_label := $DamageLabel
@onready var damage_label_timer := $DamageLabel/DamageLabelTimer
@onready var death_timer := $DeathTimer
var world: World = null
var player: Player = null
var armor: int
var damage: int
var direction: Vector2
var enemy_name: String
var fleeing := false
var health: int
var speed: float
var xp_value: int


func _ready() -> void:
	# this is in case the enemy never enters screen for some reason
	banish_timer.start(DEFAULT_BANISH_TIME)


func _physics_process(_delta: float) -> void:
	if direction.x > 0.0:
		animated_sprite.flip_h = false
	elif direction.x < 0.0:
		animated_sprite.flip_h = true

	velocity = direction * speed
	move_and_slide()


func die() -> void:
	set_process(false)
	set_physics_process(false)
	set_collision_layer_value(3, false)
	$AITimer.set_paused(true)
	die_effects()
	death_timer.start(DEFAULT_DAMAGE_LABEL_TIME)


func die_effects() -> void:
	animated_sprite.set_visible(false)


func hit(damage_in: int) -> void:
	health -= damage_in
	damage_label.set_text(str(damage_in))
	damage_label.set_visible(true)
	damage_label_timer.start(DEFAULT_DAMAGE_LABEL_TIME)
	if health <= 0:
		die()
	else:
		animation_player.play("hit")


func _on_ai_timer_timeout() -> void:
	if fleeing:
		direction = -(player.position - position).normalized()
	else:
		direction = (player.position - position).normalized()


func _on_death_timer_timeout() -> void:
	emit_signal("died", self)
	emit_signal("died_on_a_pack")
	queue_free()


func _on_damage_label_timer_timeout() -> void:
	damage_label.set_visible(false)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	banish_timer.stop()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	banish_timer.start(DEFAULT_BANISH_TIME)


func _on_banish_timer_timeout() -> void:
	emit_signal("banished")
	queue_free()
