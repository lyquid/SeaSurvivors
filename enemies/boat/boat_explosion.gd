extends Node2D

const DEFAULT_WRECKAGE_DURATION := 5.0

@onready var explosion := $Explosion
@onready var pieces := $Pieces
var tween: Tween


func _ready() -> void:
	tween = create_tween()
	# explosion
	tween.tween_property(explosion, "modulate", Color.TRANSPARENT, DEFAULT_WRECKAGE_DURATION) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	explosion.lifetime = DEFAULT_WRECKAGE_DURATION
	explosion.emitting = true
	# pieces
	tween.parallel().tween_property(pieces, "modulate", Color.TRANSPARENT, DEFAULT_WRECKAGE_DURATION) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	pieces.lifetime = DEFAULT_WRECKAGE_DURATION
	pieces.emitting = true
	# clean
	tween.tween_callback(queue_free)
