extends LethalObstacle


func _ready():
	$AnimatedSprite2D.play()


func move_sin(starting_position_y: float):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
