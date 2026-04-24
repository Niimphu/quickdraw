extends Line2D

@export var trail_length := 25

func _ready() -> void:
	clear_points()


func _process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	
	add_point(get_parent().global_position)
	while get_point_count() > trail_length:
		remove_point(0)
