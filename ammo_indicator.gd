extends TextureProgressBar

@export var MaskBar: ProgressBar
@export var ChargedBullets: TextureProgressBar

var current_ammo: int = 6
var current_charged: int = 0
var empty_ammo: int = 0


func _ready() -> void:
	EventBus.ammo_changed.connect(update_ammo)
	EventBus.charged_bullet.connect(update_charged_bullets)
	

func update_ammo(new_value: int) -> void:
	current_ammo = new_value
	empty_ammo = 6 - current_ammo
	value = new_value
	update()


func update_charged_bullets(new_value: int) -> void:
	current_charged = new_value
	update()


func update() -> void:
	ChargedBullets.value = current_ammo
	MaskBar.value = current_charged + empty_ammo
