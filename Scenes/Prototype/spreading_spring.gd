extends LethalObstacle


@export var speed:int = 850
@export var acceleration_speed:int = 200
@export var min_acceleration_interval:float = 6.0
@export var max_acceleration_interval:float = 10.0
@export var acceleration_cooldown:float = 2.0
var acceleration_cooldown_counter:float = 0.0


func _ready():
	$AnimatedSprite2D.play()
	reset_acceleration_timer()


func _process(delta):
	position.x = position.x + (delta * speed)
	
	if acceleration_cooldown_counter > 0:
		acceleration_cooldown_counter -= delta
	
	if acceleration_cooldown_counter < 0:
		print("SPRING SLOW")
		acceleration_cooldown_counter = 0.0
		speed -= acceleration_speed
		reset_acceleration_timer()
	


func reset_acceleration_timer():
	$AccelerationTimer.wait_time = randf_range(min_acceleration_interval, max_acceleration_interval)
	$AccelerationTimer.start()


func _on_player_hit():
	speed = 0
	acceleration_cooldown_counter = 0.0
	$AccelerationTimer.stop()


func on_acceleration_timer_timeout():
	print("SPRING FAST")
	speed += acceleration_speed
	acceleration_cooldown_counter = acceleration_cooldown
	$AccelerationTimer.stop()
