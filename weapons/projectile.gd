class_name Projectile extends Area2D

@onready var disable_timer := $DisableTimer
@onready var sprite := $AnimatedSprite2D
var damage: int
var speed: float
var direction: Vector2
var disable_time: float
var piercing_power: int


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
	# splash!!
	queue_free()
