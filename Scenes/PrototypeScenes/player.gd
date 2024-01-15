class_name Player
extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# signal player_moved_right

func _ready():
	$AnimatedSprite2D.play()
	
	# Set initial camera left boundary
	var current_camera_left_boundary = position.x - (get_viewport_rect().size.x/2)
	$Camera2D.set_limit(SIDE_LEFT, current_camera_left_boundary)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move-left"):
		direction.x -= 1
	if Input.is_action_pressed("move-right"):
		direction.x += 1
		
		var camera_left_limit = $Camera2D.get_limit(SIDE_LEFT)
		var current_camera_left_boundary = position.x - (get_viewport_rect().size.x/2)
		
		# Set new camera limit_left
		if camera_left_limit < current_camera_left_boundary:
			$Camera2D.set_limit(SIDE_LEFT, current_camera_left_boundary)
		
		# player_moved_right.emit()
	
	if direction != Vector2.ZERO:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
