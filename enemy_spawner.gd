extends Node2D

@onready var test_enemy := preload("res://enemy.tscn")
@onready var spawn_timer := Timer.new()
var spawn_distance := 700

func _ready() -> void:
	add_child(spawn_timer)
	spawn_timer.wait_time = 2.5
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_enemy)


func spawn_enemy() -> void:
	var new_enemy := test_enemy.instantiate()
	var direction := Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	new_enemy.global_position = get_node("Player").global_position + (direction * spawn_distance)
	add_child(new_enemy)
