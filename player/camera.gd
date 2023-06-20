extends Camera2D

# Lower cap for the `_zoom_level`.
@export var min_zoom := 0.1
# Upper cap for the `_zoom_level`.
@export var max_zoom := 20.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor := 0.1
# Duration of the zoom's tween animation.
@export var zoom_duration := 0.2
# The camera's target zoom level.
var zoom_level := 1.0 


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom_level += zoom_factor
	elif event.is_action_pressed("zoom_out"):
		zoom_level -= zoom_factor

	set_zoom_level(zoom_level)


func set_zoom_level(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	var tween := create_tween()
	tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_duration)
	tween.set_trans(tween.TRANS_SINE)
	tween.set_ease(tween.EASE_OUT)
