class_name Weapon extends Node2D

@onready var world := get_tree().root.get_node("Main/World")
@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var sprite := $AnimatedSprite2D
@onready var cooldown_timer := $CooldownTimer
var cooldown: float
var damage: int
var piercing_power: int
var projectile_disable_time: float
var speed: float


func fire() -> void:
	pass


func _on_cooldown_timer_timeout() -> void:
	fire()
