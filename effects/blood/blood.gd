extends GPUParticles2D

const DEFAULT_BLOOD_DURATION := 5.0

@onready var death_timer := $DeathTimer
var tween: Tween


func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DEFAULT_BLOOD_DURATION)
	lifetime = DEFAULT_BLOOD_DURATION
	emitting = true
	death_timer.wait_time = DEFAULT_BLOOD_DURATION
	death_timer.start()


func _on_death_timer_timeout() -> void:
	queue_free()
