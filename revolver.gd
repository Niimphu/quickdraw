extends Node2D

var bullet_scene := preload("res://bullet.tscn")
var bullet_speed := 4000

var ammo := 6

func shoot(bullet_position: Vector2, direction: Vector2, speed_modifier: float = 1.0) -> int:
	if ammo < 1:
		return 1
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_position
	bullet.rotate(direction.orthogonal().angle())
	get_parent().get_parent().add_child(bullet)
	bullet.fire(direction, bullet_speed)
	ammo -= 1
	
	return 0

func reload() -> void:
	ammo = 6
