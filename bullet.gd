extends Node2D

@export var Trail: Line2D
var velocity: Vector2
var prev_position: Vector2

func _ready() -> void:
	set_physics_process(false)

func fire(direction: Vector2, speed: float) -> void:
	set_lifetime()
	velocity = direction.normalized() * speed
	prev_position = global_position
	set_physics_process(true)


func set_lifetime():
	var timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	var new_position = global_position + velocity * delta

	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsRayQueryParameters2D.create(prev_position, new_position)
	#query.exclude = [self]
#
	#var result = space_state.intersect_ray(query)
#
	#if result:
		##on_hit(result)
		#queue_free()
		#return

	global_position = new_position
	prev_position = new_position
