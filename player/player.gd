class_name Player extends CharacterBody2D

const DEFAULT_SPEED := 200.0
@onready var sprite := $Sprite2D


func _physics_process(_delta: float):
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * DEFAULT_SPEED
	
	if direction.x < 0.0:
		sprite.flip_h = true
	elif direction.x > 0.0:
		sprite.flip_h = false
		
	move_and_slide()
