class_name Player extends CharacterBody2D

const DEFAULT_SPEED := 100.0

@onready var sprite := $Sprite2D
var speed := DEFAULT_SPEED
var facing_left := false
var last_direction := Vector2.RIGHT
# leveling stuff
var level := 1
var experience := 0
var experience_until_new_level := 5


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if not direction.is_zero_approx():
		last_direction = direction
		
	velocity = direction * speed
	
	if direction.x < 0.0:
		sprite.flip_h = true
		facing_left = true
	elif direction.x > 0.0:
		sprite.flip_h = false
		facing_left = false
	
	move_and_slide()


func add_experience(how_much: int) -> void:
	experience += how_much
	var residue := 0
	if experience >= experience_until_new_level:
		residue = experience - experience_until_new_level
		level += 1
		new_level()
		experience = 0
		print("LEVEL ", level, ", xp until new level: ", experience_until_new_level)

#	emit_signal("experience_changed", experience * 100.0 / experience_until_new_level)
	if residue:
		add_experience(residue)


func new_level() -> void:
	if level == 1:
		return
	if level <= 20:
		experience_until_new_level += 10
		return
	if level <= 40:
		experience_until_new_level += 13
		return
	# level 41 and onward
	experience_until_new_level += 16


func _on_pickup_attractor_area_entered(pickup: Pickup) -> void:
	pickup.go_to_player()


func _on_pickup_area_area_entered(pickup: Pickup) -> void:
	pickup.player_touched()
