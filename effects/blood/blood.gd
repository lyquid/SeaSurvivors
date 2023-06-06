extends GPUParticles2D

const DEFAULT_BLOOD_DURATION := 5.0

var tween: Tween


func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DEFAULT_BLOOD_DURATION) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	lifetime = DEFAULT_BLOOD_DURATION
	emitting = true
	# clean
	tween.tween_callback(queue_free)
