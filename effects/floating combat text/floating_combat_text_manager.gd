class_name FloatingCombatTextManager extends Node2D

var floating_combat_text_scene := preload("res://effects/floating combat text/floating_combat_text.tscn")

@export var duration := 1.0
@export var spread := PI * 0.5
@export var travel := Vector2(0.0, -30.0)


func show_value(value, crit := false) -> void:
	var fct := floating_combat_text_scene.instantiate()
	add_child(fct)
	fct.show_value(str(value), travel, duration, spread, crit)
