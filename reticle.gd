extends TextureRect

var centre_dot = load("res://img/centredot.png")
func _ready():
	Input.set_custom_mouse_cursor(centre_dot, 0, Vector2(4, 4))
	EventBus.accuracy_modifier_changed.connect(_on_accuracy_modifier_changed)


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size * scale / 2)


func _on_accuracy_modifier_changed(value: float) -> void:
	scale = Vector2(value, value)
