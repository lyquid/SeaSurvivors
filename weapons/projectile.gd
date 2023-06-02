class_name Projectile extends Area2D

@onready var disable_timer := $DisableTimer
@onready var sprite := $AnimatedSprite2D
var damage: int
var speed: float
var direction: Vector2
var disable_time: float
var piercing_power: int
var splash_scene := preload("res://effects/splash/splash.tscn")


func _ready() -> void:
	disable_timer.wait_time = disable_time
	disable_timer.start()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(enemy: Enemy) -> void:
	enemy.hit(damage)
	piercing_power = piercing_power - enemy.armor
	if not piercing_power:
		queue_free()


func _on_disable_timer_timeout() -> void:
	var splash := splash_scene.instantiate()
	splash.global_position = global_position
	get_parent().call_deferred("add_child", splash)
	queue_free()
