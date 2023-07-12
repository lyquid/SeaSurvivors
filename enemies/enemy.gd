class_name Enemy extends CharacterBody2D

signal banished
signal died
signal died_on_a_pack

const DEFAULT_BANISH_TIME := 10.0

static var lights_on := false

@onready var animated_sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer
@onready var banish_timer := $VisibleOnScreenNotifier2D/BanishTimer
@onready var death_timer := $DeathTimer
@onready var fct_manager := $FloatingCombatTextManager
@onready var light := $Light
@onready var navigation_agent := $NavigationAgent2D
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
	light.set_enabled(lights_on)
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
	light.set_enabled(false)
	$LightOccluder2D.set_visible(false)
	$AITimer.set_paused(true)
	die_effects()
	death_timer.start(fct_manager.duration)


func die_effects() -> void:
	animated_sprite.set_visible(false)


func hit(damage_in: int) -> void:
	health -= damage_in
	var crit := randi_range(0, 1)
	fct_manager.show_value(damage_in, crit)
	if health <= 0:
		die()
	else:
		animation_player.play("hit")


func make_path_to_player() -> void:
	navigation_agent.target_position = player.global_position


func set_light(status: bool) -> void:
	light.call_deferred("set_enabled", status)
	lights_on = status


func _on_ai_timer_timeout() -> void:
	if fleeing:
		direction = -(player.position - position).normalized()
	else:
		make_path_to_player()
		direction = to_local(navigation_agent.get_next_path_position()).normalized()


func _on_death_timer_timeout() -> void:
	died.emit(self)
	died_on_a_pack.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	banish_timer.stop()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	banish_timer.start(DEFAULT_BANISH_TIME)


func _on_banish_timer_timeout() -> void:
	banished.emit()
	queue_free()
