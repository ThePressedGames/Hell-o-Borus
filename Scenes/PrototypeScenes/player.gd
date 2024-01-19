class_name Player
extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play()


func _process(delta):
	position.x += delta * SPEED


func _physics_process(delta):
	if is_on_floor():
		$AnimatedSprite2D.animation = "run"
	
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
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.animation = "jump"
	
	move_and_slide()


func _on_obstacle_body_entered(body):
	print("Obstacle hit!")
	$AnimatedSprite2D.animation = "death"
