class_name PickupsManager extends Node

const MAX_EXPERIENCE_GEMS := 200

@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var world := get_tree().root.get_node("Main/World")
var xp_scene := preload("res://pickups/experience/experience_gem.tscn")
var experience_gems_count := 0


func _process(_delta: float) -> void:
	if experience_gems_count > MAX_EXPERIENCE_GEMS:
		get_tree().call_deferred("call_group", "experience_gems", "go_to_player")


func drop_experience_gem(where: Vector2, xp_value: int) -> void:
	var xp_gem := xp_scene.instantiate() as Pickup
	xp_gem.player = player
	xp_gem.value = xp_value
	xp_gem.set_global_position(where)
	xp_gem.connect("picked", _on_experience_gem_picked)
	world.call_deferred("add_child", xp_gem)
	experience_gems_count += 1


func _on_experience_gem_picked() -> void:
	experience_gems_count -= 1
