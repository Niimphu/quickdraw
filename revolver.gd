extends Node2D

@export var FireDelay: Timer
@export var ReloadDelay: Timer
@export var firing_delay := 0.3
@export var reload_delay := 0.25
@export var max_ammo := 6

var bullet_scene := preload("res://bullet.tscn")
var bullet_speed := 4000
var shooting := false
var ammo := max_ammo

func _ready() -> void:
	FireDelay.wait_time = firing_delay
	FireDelay.timeout.connect(_on_fire_delay_timeout)
	ReloadDelay.wait_time = reload_delay
	ReloadDelay.timeout.connect(_on_reload_delay_timeout)


func shoot(bullet_position: Vector2, direction: Vector2, ignore_delay: bool = false) -> int:
	if ammo < 1 or shooting:
		return 1
	
	ReloadDelay.stop()
	
	if not ignore_delay:
		FireDelay.start()
		shooting = true
	
	spawn_bullet(bullet_position, direction)
	change_ammo(-1)
	
	return 0


func change_ammo(amount: int) -> void:
	ammo += amount
	EventBus.ammo_changed.emit(ammo)


func spawn_bullet(bullet_position: Vector2, direction: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_position
	bullet.rotate(direction.orthogonal().angle())
	get_parent().get_parent().get_node("Bullets").add_child(bullet)
	bullet.fire(direction, bullet_speed)


func reload() -> void:
	if ReloadDelay.is_stopped():
		ReloadDelay.start()


func cancel_reload() -> void:
	ReloadDelay.stop()


func _on_fire_delay_timeout() -> void:
	shooting = false


func _on_reload_delay_timeout() -> void:
	if ammo < max_ammo:
		change_ammo(-1)
		if ammo < max_ammo:
			ReloadDelay.start()
