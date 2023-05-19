class_name Projectile extends Area2D

@onready var disable_timer := $DisableTimer
var damage: int
var speed: float
var direction: Vector2
var disable_time: float


func _ready():
	disable_timer.wait_time = disable_time
	disable_timer.start()


func _physics_process(delta: float):
	position += direction * speed * delta


func _on_body_entered(enemy: Enemy):
	enemy.hit(damage)
	queue_free()


func _on_disable_timer_timeout():
	# splash!!
	queue_free()
