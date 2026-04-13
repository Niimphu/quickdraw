extends TextureRect

func _physics_process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size * scale / 2)
