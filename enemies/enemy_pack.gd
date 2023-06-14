class_name EnemyPack extends Node2D

var rng := RandomNumberGenerator.new()
var size := 0
var state := {
	"aggressive": false,
	"chaotic": false,
	"fleeing": false,
	"passive": true
}


func _init() -> void:
	rng.randomize()


func make_pack_aggressive() -> void:
	for enemy in get_children():
		enemy.get_node("AITimer").set_paused(false)
	state["aggressive"] = true
	state["chaotic"] = false
	state["fleeing"] = false
	state["passive"] = false


func make_pack_chaotic() -> void:
	for enemy in get_children():
		var dice := rng.randi_range(1, 3)
		if dice == 1: # attack
			enemy.get_node("AITimer").set_paused(false)
		elif dice == 2: # flee
			enemy.fleeing = true
			enemy.get_node("AITimer").set_paused(false)
	state["aggressive"] = false
	state["chaotic"] = true
	state["fleeing"] = false
	state["passive"] = false


func make_pack_flee() -> void:
	for enemy in get_children():
		enemy.fleeing = true
		enemy.get_node("AITimer").set_paused(false)
	state["aggressive"] = false
	state["chaotic"] = false
	state["fleeing"] = true
	state["passive"] = false


func make_pack_passive() -> void:
	for enemy in get_children():
		enemy.get_node("AITimer").set_paused(true)
	state["aggressive"] = false
	state["chaotic"] = false
	state["fleeing"] = false
	state["passive"] = true


func get_state() -> Dictionary:
	return state


func _on_enemy_death() -> void:
	size -= 1
	if not size:
		queue_free()
		return
	if state["passive"]:
		var dice := rng.randi_range(1, 10)
		if dice < 7:
			return
		elif dice < 8:
			call_deferred("make_pack_aggressive")
			return
		elif dice < 9:
			call_deferred("make_pack_flee")
			return
		else:
			call_deferred("make_pack_chaotic")
