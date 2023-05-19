class_name WeaponManager extends Node

@onready var player := get_tree().root.get_node("Main/World/Player")
# weapons
enum { CANNON, MEGALASER }
var cannon_scene := preload("res://weapons/cannon/cannon.tscn")


func _ready():
	player.call_deferred("add_child", cannon_scene.instantiate())
