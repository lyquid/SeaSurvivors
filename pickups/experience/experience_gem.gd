extends Pickup

var value: int


func player_touched() -> void:
	player.add_experience(value)
	queue_free()
