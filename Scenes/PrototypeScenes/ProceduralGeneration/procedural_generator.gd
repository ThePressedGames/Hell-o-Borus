# @tool
extends Node2D

# Bottom limit to instantiate ground tiles in px
@export var ground_bottom_limit = 640

@export var player: Player

# var instantiated_tiles: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Static body for ground
	var ground = StaticBody2D.new()
	
	# Ground collision shape setup
	var ground_collision = CollisionShape2D.new()
	var ground_shape = RectangleShape2D.new()
	ground_shape.size = Vector2(10000, 20)
	ground_collision.set_shape(ground_shape)
	ground.add_child(ground_collision)
	
	# Ground mesh setup
	var ground_mesh_instance = MeshInstance2D.new()
	var ground_mesh = QuadMesh.new()
	ground_mesh.size = ground_shape.size
	ground_mesh_instance.set_mesh(ground_mesh)
	ground.add_child(ground_mesh_instance)
	
	# Ground positioning and instantiating
	ground.set_position(Vector2(500, ground_bottom_limit))
	add_child(ground)
	
	# instantiated_tiles.append(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# func _on_player_player_moved_right():
# 	pass # Replace with function body.
