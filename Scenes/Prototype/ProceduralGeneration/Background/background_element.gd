@tool
extends Sprite2D


# Array with all the possible textures that a background element can have
@export var element_sprites: Array[Texture2D]
@export var snow_packs_sprites: Array[Texture2D]


func _ready():
	if !element_sprites.is_empty():
		# Randomize texture
		var random_sprite = element_sprites.pick_random()
		texture = random_sprite
		
		if not snow_packs_sprites.is_empty():
			var random_snow_sprite = snow_packs_sprites.pick_random()
			$SnowPackSprite.texture = random_snow_sprite
			$SnowPackSprite.modulate = Color(1.05, 1.05, 1.05)

func update_position(x_offset: float, y_offset: float):
	position.x = x_offset
	position.y = y_offset + randf_range(0, 20)


func calculate_next_offset(current_offset: float, min_spacing: int, max_spacing: int):
	return current_offset + randi() % (max_spacing - min_spacing) + min_spacing


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
