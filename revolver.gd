extends Node2D

@export var FireDelay: Timer

var bullet_scene := preload("res://bullet.tscn")
var bullet_speed := 4000
var shooting := false
var firing_delay := 0.2
var ammo := 6

func _ready() -> void:
	FireDelay.wait_time = firing_delay
	FireDelay.timeout.connect(_on_fire_delay_timeout)


func shoot(bullet_position: Vector2, direction: Vector2, speed_modifier: float = 1.0) -> int:
	if ammo < 1 or shooting:
		return 1
	
	FireDelay.start()
	shooting = true
	spawn_bullet(bullet_position, direction, speed_modifier)
	ammo -= 1
	
	return 0


func spawn_bullet(bullet_position: Vector2, direction: Vector2, speed_modifier: float):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_position
	bullet.rotate(direction.orthogonal().angle())
	get_parent().get_parent().add_child(bullet)
	bullet.fire(direction, bullet_speed)


func reload() -> void:
	ammo = 6


func _on_fire_delay_timeout() -> void:
	shooting = false
