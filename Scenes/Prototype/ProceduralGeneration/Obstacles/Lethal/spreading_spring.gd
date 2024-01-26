extends LethalObstacle


@export var speed:int = 850
var difficulty_speed_modifier:float = 1
@export var acceleration_speed:int = 200
@export var min_acceleration_interval:float = 6.0
@export var max_acceleration_interval:float = 10.0
@export var acceleration_cooldown:float = 2.0
var acceleration_cooldown_counter:float = 0.0


func _ready():
	$AnimatedSprite2D.play()
	reset_acceleration_timer()


func _process(delta):
	position.x = position.x + (delta * speed * difficulty_speed_modifier)
	
	if acceleration_cooldown_counter > 0:
		acceleration_cooldown_counter -= delta
	
	if acceleration_cooldown_counter < 0:
		acceleration_cooldown_counter = 0.0
		speed -= acceleration_speed * difficulty_speed_modifier
		reset_acceleration_timer()
	


func reset_acceleration_timer():
	$AccelerationTimer.wait_time = randf_range(min_acceleration_interval, max_acceleration_interval)
	$AccelerationTimer.start()


func _on_player_hit():
	speed = 0
	acceleration_cooldown_counter = 0.0
	$AccelerationTimer.stop()


func on_acceleration_timer_timeout():
	speed += acceleration_speed * difficulty_speed_modifier
	acceleration_cooldown_counter = acceleration_cooldown
	$AccelerationTimer.stop()


func _on_main_scene_speed_modifier_update(speed_modifier: float):
	difficulty_speed_modifier = speed_modifier
