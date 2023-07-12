extends Label

@export var crit_color := Color.RED
@export var text_color := Color.WHITE


func _ready() -> void:
	modulate = text_color


func show_value(value: String, travel: Vector2, duration: float, spread: float, crit := false) -> void:
	text = value
	var movement := travel.rotated(randf_range(-spread * 0.5, spread * 0.5))
	pivot_offset = size * 0.5
	
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position + movement, duration)
	tween.parallel().tween_property(self, "modulate:a", 0.0, duration)
	
	if crit:
		modulate = crit_color
		tween.parallel().tween_property(self, "scale", scale, duration * 0.2).from(scale * 2.0) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(queue_free)
