extends CharacterBody2D

@export var Gun: Node2D

var direction := Vector2.ZERO
var speed := 300
var accuracy := 11
var accuracy_modifier := 1.0
var min_accuracy_modifier := 0.5
var holstered:= false


func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and not holstered:
		Gun.shoot(global_position, get_bullet_direction())
	if event.is_action_pressed("reload"):
		Gun.reload()
	if event.is_action_pressed("scroll_up"):
		change_accuracy_modifier(-0.2)
	if event.is_action_pressed("scroll_down"):
		change_accuracy_modifier(0.2)


func change_accuracy_modifier(amount: float) -> void:
	accuracy_modifier += amount
	if accuracy_modifier < 0.5:
		accuracy_modifier = 0.5
	EventBus.accuracy_modifier_changed.emit(accuracy_modifier)


func get_bullet_direction() -> Vector2:
	var center := get_global_mouse_position()
	var radius := accuracy * accuracy_modifier

	var angle := randf() * TAU
	var r := sqrt(randf()) * radius

	var offset := Vector2(cos(angle), sin(angle)) * r

	return center + offset - global_position


func _on_holster_box_mouse_entered() -> void:
	holstered = true


func _on_holster_box_mouse_exited() -> void:
	holstered = false
