class_name Player
extends CharacterBody2D

signal hit
signal score_distance_up

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var falling_velocity_multiplier: float = 4
# Coyote effect
@export var hang_time: float = .3
var hang_time_counter: float
# Expanded time slot to let the player jump before landing
@export var jump_buffer_time: float = .3
var jump_buffer_time_counter: float

@export var score_distance:int = 100
var starting_score_position
var score_position_counter

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play()
	starting_score_position = global_position.x


func _process(delta):
	position.x += delta * speed


func _physics_process(delta):
	if is_on_floor():
		$AnimatedSprite2D.animation = "run"
		hang_time_counter = hang_time
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move-left"):
		direction.x -= .5
	if Input.is_action_pressed("move-right"):
		direction.x += .25
		
	if direction != Vector2.ZERO:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * falling_velocity_multiplier
		hang_time_counter -= delta
	
	# Handle jump.
	# When jump button is pressed, start a time buffer to make the player jump as soon as he can
	if Input.is_action_pressed("jump"):
		jump_buffer_time_counter = jump_buffer_time
	
	# Slow down ascension when jump button in released mid-jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		#print("Slow down!")
		velocity.y = velocity.y * .2
	
	if jump_buffer_time_counter > 0:
		jump_buffer_time_counter -= delta
	
	if jump_buffer_time_counter > 0 and hang_time_counter > 0:
		velocity.y = jump_velocity
		$AnimatedSprite2D.animation = "jump"
		jump_buffer_time_counter = 0
	
	move_and_slide()
	
	score_position_counter = global_position.x	
	if (score_position_counter - starting_score_position) > score_distance:
		starting_score_position += score_distance
		score_distance_up.emit()
	


func _on_obstacle_body_entered(body):	
	if body is LethalObstacle:
		
		if body.name == "HedgehogObstacle":
			body.get_node("AnimatedSprite2D").play()
		
		print("Obstacle name: " + body.name)
		position.y -= 40
		set_process(false)
		set_physics_process(false)
		$AnimatedSprite2D.animation = "death"
		
		hit.emit()
