extends Area2D


@export var speed:int = 400


func _process(delta):
	position.x = position.x + (delta * speed)
