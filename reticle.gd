extends TextureRect


func _ready() -> void:
	EventBus.accuracy_modifier_changed.connect(_on_accuracy_modifier_changed)


func _physics_process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size * scale / 2)


func _on_accuracy_modifier_changed(value: float) -> void:
	scale = Vector2(value, value)
