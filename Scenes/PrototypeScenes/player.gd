class_name Player
extends CharacterBody2D

signal hit

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var falling_velocity_multiplier: float = 4
# Coyote effect
@export var hang_time: float = .3
var hang_time_counter: float
# Expanded time slot to let the player jump before landing
@export var jump_buffer_time: float = .3
var jump_buffer_time_counter: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play()


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
		$Camera2D.position.x += 5
	if Input.is_action_pressed("move-right"):
		direction.x += .7
		$Camera2D.position.x -= 7
		
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
		print("Slow down!")
		velocity.y = velocity.y * .2
	
	if jump_buffer_time_counter > 0:
		jump_buffer_time_counter -= delta
	
	if jump_buffer_time_counter > 0 and hang_time_counter > 0:
		velocity.y = jump_velocity
		$AnimatedSprite2D.animation = "jump"
		jump_buffer_time_counter = 0
	
	move_and_slide()


func _on_obstacle_body_entered(body):
	#print("Obstacle hit!")
	position.y -= 40
	set_process(false)
	set_physics_process(false)
	$AnimatedSprite2D.animation = "death"
	
	hit.emit()
