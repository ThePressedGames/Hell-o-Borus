@tool
extends Node2D


# Array with all the possible textures that a background element can have
@export var sprites: Array[Texture2D]

var spacing_min = 200
var spacing_max = 800


func _ready():
	if !sprites.is_empty():
		# Randomize texture
		var random_sprite = sprites.pick_random()
		$Sprite2D.texture = random_sprite


func calculate_position(x_offset: float):
	position.x = x_offset
	position.y = 400


func calculate_next_offset(current_offset: float):
	return current_offset + randi() % (spacing_max - spacing_min) + spacing_min
