@tool
extends LethalObstacle


@export var max_height = 250
@export var min_height = 460
@export var y_speed = 300
@export var x_speed = 1250
var direction = Vector2(1, 1)

@export var spawn_sounds:Array[AudioStreamMP3]


func _ready():
	$AnimatedSprite2D.play()
	position.y = randf_range(max_height, min_height)
	x_speed = randf_range(x_speed - 50, x_speed + 50)


func _process(delta):
	if position.y < max_height:
		direction.y = 1
	elif position.y > min_height:
		direction.y = -1
	
	position.y += direction.y * delta * y_speed
	position.x += delta * x_speed


func update_speed(speed_modifier: float):
	x_speed *= speed_modifier


func _on_visible_on_screen_notifier_2d_screen_entered():
	var spawn_sfx = spawn_sounds.pick_random()
	$AudioStreamPlayer.stream = spawn_sfx
	$AudioStreamPlayer.play()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
