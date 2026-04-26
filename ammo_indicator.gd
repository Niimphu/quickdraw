extends TextureProgressBar

@export var MaskBar: ProgressBar
@export var ChargedBullets: TextureProgressBar


func _ready() -> void:
	EventBus.ammo_changed.connect(update_ammo)
	EventBus.charged_bullet.connect(update_charged_bullets)


func update_ammo(new_value: int) -> void:
	value = new_value
	MaskBar.value = new_value


func update_charged_bullets(new_value: int) -> void:
	ChargedBullets.value = new_value
