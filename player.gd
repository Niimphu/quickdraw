extends CharacterBody2D

@export var Gun: Node2D
@export var ChargeInterval: Timer
@export var FocusFireWindow: Timer
@export var RollCooldown: Timer
@export var RollTime: Timer
@export var move_speed := 300
@export var Sprite : Sprite2D

var direction := Vector2.ZERO
var speed: float = move_speed
var accuracy_modifier := 1.0
var reticle_radius := 1
var min_accuracy_modifier := 0.5
var base_accuracy := deg_to_rad(10)
var holstered := false
var rolling := false
var roll_speed := 1000

var focused := false
var focus_level := 0
var focus_walk_speed_modifier := 0.4
var charged_bullets := 0


func _ready() -> void:
	ChargeInterval.timeout.connect(_on_charge_interval_timeout)
	FocusFireWindow.timeout.connect(_on_focus_fire_window_timeout)
	RollTime.timeout.connect(_on_roll_time_timeout)


func _physics_process(_delta: float) -> void:
	if rolling:
		velocity = direction * roll_speed
	else:
		direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and not holstered:
		shoot_gun()
	if event.is_action_pressed("reload") and not holstered:
		reload_gun()
	if event.is_action_pressed("roll"):
		roll()
	#if event.is_action_pressed("scroll_up"):
		#change_accuracy_modifier(-0.2)
	#if event.is_action_pressed("scroll_down"):
		#change_accuracy_modifier(0.2)
	if event is InputEventMouseMotion:
		update_accuracy()


func update_accuracy() -> void:
	if focused:
		return
	var player_to_mouse = get_global_mouse_position() - global_position
	var distance := player_to_mouse.length()
	var accuracy := base_accuracy #calculate
	reticle_radius = int(distance * sin(accuracy / 2.0))
	
	EventBus.accuracy_changed.emit(reticle_radius)


func change_accuracy_modifier(amount: float) -> void:
	accuracy_modifier += amount
	if accuracy_modifier < 0.5:
		accuracy_modifier = 0.5
	EventBus.accuracy_changed.emit(accuracy_modifier)


func shoot_gun() -> void:
	if rolling or holstered:
		return
	var ignore_delay: bool = charged_bullets > 1
	if Gun.shoot(global_position, get_bullet_direction(), ignore_delay) == 0:
		Gun.cancel_reload()
		if charged_bullets > 0:
			change_charged_bullets(-1)
			if charged_bullets == 0:
				_on_focus_fire_window_timeout()
				if Gun.ammo == 0:
					reload_gun()
		#shooting animation
		pass


func reload_gun() -> void:
	#reload animation
	if rolling or holstered:
		return
	if Gun.reload() == 0:
		#update
		pass


func get_bullet_direction() -> Vector2:
	var center := get_global_mouse_position()

	var angle := randf() * TAU
	var r := sqrt(randf()) * reticle_radius

	var offset := Vector2(cos(angle), sin(angle)) * r

	return center + offset - global_position


func roll() -> void:
	if not RollCooldown.is_stopped():
		return
	_on_holster_box_mouse_exited()
	Gun.cancel_reload()
	direction = Input.get_vector("left", "right", "up", "down")
	rolling = true
	RollTime.start()
	
	var tween := get_tree().create_tween()
	var roll_direction := direction.x
	if direction.x > 0:
		roll_direction = 360
	elif direction.x < 0:
		roll_direction = -360
	elif get_global_mouse_position().x - global_position.x > 0:
		roll_direction = 360
	else:
		roll_direction = -360
	tween.tween_property(Sprite, "rotation_degrees", roll_direction, 0.15)
	await tween.finished
	Sprite.rotation = 0


func _on_roll_time_timeout() -> void:
	rolling = false
	RollCooldown.start()


func _on_holster_box_mouse_entered() -> void:
	if Gun.ammo < 1 or charged_bullets > 0:
		return
	Gun.cancel_reload()
	holstered = true
	ChargeInterval.start()


func _on_holster_box_mouse_exited() -> void:
	holstered = false
	ChargeInterval.stop()
	FocusFireWindow.start()


func _on_charge_interval_timeout() -> void:
	if not focused:
		focused = true
		speed = move_speed * focus_walk_speed_modifier
	elif charged_bullets < Gun.max_ammo:
		if charged_bullets < Gun.ammo:
			change_charged_bullets(1)
		if charged_bullets == Gun.max_ammo:
			#indicate fully focused
			pass


func change_charged_bullets(amount: int) -> void:
	if amount == 0:
		charged_bullets = 0
	else:
		charged_bullets += amount
	EventBus.charged_bullet.emit(charged_bullets)


func _on_focus_fire_window_timeout() -> void:
	focused = false
	update_accuracy()
	speed = move_speed
	change_charged_bullets(0)
	accuracy_modifier = 1
	#change_accuracy_modifier(0)
