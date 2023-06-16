extends Pickup

signal picked

var value: int


func player_touched() -> void:
	player.add_experience(value)
	picked.emit()
	queue_free()
