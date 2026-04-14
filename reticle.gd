extends TextureRect

var current_tween: Tween

var centre_dot = load("res://img/centredot.png")
func _ready():
	Input.set_custom_mouse_cursor(centre_dot, 0, Vector2(4, 4))
	EventBus.accuracy_modifier_changed.connect(_on_accuracy_modifier_changed)


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size * scale / 2)


func _on_accuracy_modifier_changed(value: float) -> void:
	if current_tween and current_tween.is_valid() and current_tween.is_running():
		current_tween.kill()
	
	current_tween = get_tree().create_tween()
	current_tween.tween_property(self, "scale", Vector2(value, value), 0.2)
