class_name MapTile
extends StaticBody2D


func _on_visible_on_screen_notifier_2d_screen_entered():
	# print("Map tile entered the screen!")
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	# print("Map tile exited the screen!")
	queue_free()
