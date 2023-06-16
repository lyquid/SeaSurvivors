extends Weapon

const DEFAULT_ANCHOR_COOLDOWN := 1.0
const DEFAULT_ANCHOR_DAMAGE := 8
const DEFAULT_ANCHOR_DURATION := 20.0
const DEFAULT_ANCHOR_SPEED := 4.0
const DEFAULT_ANCHOR_DISTANCE := 30.0
const DEFAULT_ANCHOR_DISTANCE_INCREMENT := 4.0

@onready var anchor_sprite := $DamageArea/Sprite2D
@onready var damage_area := $DamageArea
@onready var duration_timer := $DurationTimer
@onready var rope := $Rope
var angle := 0.0
var distance := DEFAULT_ANCHOR_DISTANCE
var duration := DEFAULT_ANCHOR_DURATION


func _ready() -> void:
	set_process(false)
	damage = DEFAULT_ANCHOR_DAMAGE
	speed = DEFAULT_ANCHOR_SPEED
	anchor_sprite.set_visible(false)
	rope.add_point(to_local(player.global_position), 0)
	rope.add_point(anchor_sprite.global_position, 1)
	cooldown = DEFAULT_ANCHOR_COOLDOWN
	cooldown_timer.start(cooldown)


func _process(delta: float) -> void:
	angle += speed * delta
	distance += delta * DEFAULT_ANCHOR_DISTANCE_INCREMENT
	damage_area.set_position(Vector2(cos(angle), sin(angle)) * distance)
	damage_area.look_at(player.global_position)
	rope.set_point_position(1, to_local(anchor_sprite.global_position))


func fire() -> void:
	set_process(true)
	damage_area.set_monitoring(true)
	anchor_sprite.set_visible(true)
	rope.set_visible(true)
	duration_timer.start(duration)


func _on_duration_timer_timeout() -> void:
	set_process(false)
	angle = 0.0
	distance = DEFAULT_ANCHOR_DISTANCE
	anchor_sprite.set_visible(false)
	damage_area.set_monitoring(false)
	rope.set_visible(false)
	cooldown_timer.start()


func _on_damage_area_body_entered(enemy: Enemy) -> void:
	enemy.hit(damage)
