extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.ammo_changed.connect(update)

func update(new_value: int) -> void:
	value = new_value
