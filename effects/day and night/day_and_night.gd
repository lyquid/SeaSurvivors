extends CanvasModulate

signal time_tick(day: int, hour: int, minute: int)

const MINUTES_PER_DAY := 1440
const MINUTES_PER_HOUR := 60
const IN_GAME_TO_REAL_MINUTE_DURATION := (2.0 * PI) / MINUTES_PER_DAY

@export var day_and_night_gradient: GradientTexture1D
@export var cycle_speed := 10.0
@export var initial_hour := 10
var time := 0.0
var past_minute := -1


func _ready() -> void:
	time = IN_GAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * initial_hour


func _process(delta: float) -> void:
	time += delta * IN_GAME_TO_REAL_MINUTE_DURATION * cycle_speed
	var sampler_value := (sin(time - PI / 2.0) + 1.0) / 2.0
	set_color(day_and_night_gradient.gradient.sample(sampler_value))
	recalculate_time()


func recalculate_time() -> void:
	var total_minutes := int(time / IN_GAME_TO_REAL_MINUTE_DURATION)
	var day := int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes := total_minutes % MINUTES_PER_DAY
	var hour := int(current_day_minutes / MINUTES_PER_HOUR)
	var minute := current_day_minutes % MINUTES_PER_HOUR
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)
#		print("day ", day, ", hour ", hour, ", minute ", minute)
