extends Node2D

@export var Player: CharacterBody2D

var reticle = load("res://img/mscrosshair.png")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
