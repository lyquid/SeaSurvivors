extends Control

# level stuff
const LEVEL_LABEL_TEXT := "Level "
@onready var level_label := $LevelLabel
@onready var level_bar := $LevelBar
var current_player_level := 1
# daytime stuff
const DAY_LABEL_TEXT := "Day "
@onready var day_label := $DayLabel
@onready var hour_label := $HourLabel


func _ready() -> void:
	level_label.set_text(LEVEL_LABEL_TEXT + str(current_player_level))
	
	level_bar.set_value(0.0)
	level_bar.max_value = 5.0


func update_level(new_level: int, xp_until_new_level: int) -> void:
	current_player_level = new_level
	level_label.set_text(LEVEL_LABEL_TEXT + str(current_player_level))
	
	level_bar.set_value(0.0)
	level_bar.max_value = xp_until_new_level


func update_level_bar_progress(new_value: int) -> void:
	level_bar.set_value(new_value)


func update_time(day: int, hour: int, minute: int) -> void:
	day_label.set_text(DAY_LABEL_TEXT + str(day))
	var final_hour: String
	if hour < 10:
		final_hour = "0" + str(hour)
	else:
		final_hour = str(hour)
	var final_minute: String
	if minute < 10:
		final_minute = "0" + str(minute)
	else:
		final_minute = str(minute)
	hour_label.set_text(final_hour + ":" + final_minute)
