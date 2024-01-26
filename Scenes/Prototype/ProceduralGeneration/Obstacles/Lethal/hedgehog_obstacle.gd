extends LethalObstacle


@export var spawn_sounds:Array[AudioStreamMP3]


func _on_visible_on_screen_notifier_2d_screen_entered():
	var spawn_sfx = spawn_sounds.pick_random()
	$AudioStreamPlayer.stream = spawn_sfx
	$AudioStreamPlayer.play()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
