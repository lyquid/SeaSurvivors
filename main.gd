class_name Main extends Node

@onready var player := get_tree().root.get_node("Main/World/Player")
@onready var day_and_night := get_tree().root.get_node("Main/World/DayAndNightCycle")
@onready var ui := $UICanvas/UI


func _ready() -> void:
	make_connections()


func _input(_event) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func make_connections() -> void:
	var err := player.connect("level_updated", ui.update_level)
	assert(not err)
	err = player.connect("experience_changed", ui.update_level_bar_progress)
	assert(not err)
	err = day_and_night.connect("time_tick", ui.update_time)
	assert(not err)
