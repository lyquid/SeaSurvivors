class_name Weapon extends Node2D

@onready var world := get_tree().root.get_node("Main/World")
@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var sprite := $AnimatedSprite2D
@onready var cooldown_timer := $CooldownTimer
var cooldown: float
var damage: int
