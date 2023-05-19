class_name Player extends CharacterBody2D

const DEFAULT_SPEED := 150.0

@onready var sprite := $Sprite2D
var speed := DEFAULT_SPEED
var facing_left := false

func _physics_process(_delta: float):
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if direction.x < 0.0:
		sprite.flip_h = true
		facing_left = true
	elif direction.x > 0.0:
		sprite.flip_h = false
		facing_left = false
		
	move_and_slide()
