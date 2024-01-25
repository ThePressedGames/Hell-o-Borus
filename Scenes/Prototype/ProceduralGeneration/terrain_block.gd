@tool
extends StaticBody2D


func spawn_block(tile_width:int, tile_height:int):
	# Collision shape setup
	var ground_shape = RectangleShape2D.new()
	ground_shape.size = Vector2(tile_width, tile_height)
	$CollisionShape2D.set_shape(ground_shape)
	
	# Ground mesh setup
	var ground_mesh = QuadMesh.new()
	ground_mesh.size = ground_shape.size
	$MeshInstance2D.set_mesh(ground_mesh)
	
	# VisibleOnScreenNotifier2D rectangle setup
	var visibility_rect_position = Vector2(-tile_width/2, -tile_height/2)
	$VisibleOnScreenNotifier2D.rect = Rect2(visibility_rect_position, ground_shape.size)


func _on_visible_on_screen_notifier_2d_screen_entered():
	# print("Map tile entered the screen!")
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	# print("Map tile exited the screen!")
	queue_free()
