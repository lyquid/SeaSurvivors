class_name WeaponManager extends Node

@onready var player := get_tree().root.get_node("Main/World/Player")
# weapons
enum { BALLISTA, CANNON }
var ballista_scene := preload("res://weapons/ballista/ballista.tscn")
var cannon_scene := preload("res://weapons/cannon/cannon.tscn")


func _ready() -> void:
	player.call_deferred("add_child", ballista_scene.instantiate())
	player.call_deferred("add_child", cannon_scene.instantiate())
