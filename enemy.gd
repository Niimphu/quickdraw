extends CharacterBody2D

var Player: CharacterBody2D
var move_speed := 100
var id: int
var time: int = 0
var direction : Vector2

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	time += delta * 100
	if time % 10 == id:
		set_direction()
	velocity = direction * move_speed
	move_and_slide()

func set_direction() -> void:
	direction = (Player.global_position - global_position).normalized()
