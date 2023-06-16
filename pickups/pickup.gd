class_name Pickup extends Area2D

const SPEED := 300.0

@onready var animated_sprite := $AnimatedSprite2D
@onready var direction_timer := $DirectionTimer
var player: Player = null
var direction := Vector2.ZERO


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	animated_sprite.play("default")


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta


func get_player_direction() -> void:
	direction = (player.global_position - global_position).normalized()


func go_to_player() -> void:
	get_player_direction()
	set_physics_process(true)
	direction_timer.start(0.25)


func player_touched() -> void:
	queue_free()


func _on_direction_timer_timeout() -> void:
	get_player_direction()
