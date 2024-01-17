@tool
extends Node2D

@export var player: Player

# Bottom limit to instantiate terrain tiles in px
var terrain_bottom_limit = 850

var terrain_block: PackedScene = preload("res://Scenes/PrototypeScenes/ProceduralGeneration/terrain_block.tscn")

@export var terrain_block_width = 800
@export var terrain_block_height = 50
var last_spawned_terrain_block = 0


# @export var obstacle: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn_terrain_block(0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_x = player.global_position.x
	
	if player_x > last_spawned_terrain_block - terrain_block_width:
		spawn_terrain_block(last_spawned_terrain_block)


func spawn_terrain_block(x_offset: float):
	var terrain_block_instance = terrain_block.instantiate()
	terrain_block_instance.spawn_block(terrain_block_width, terrain_block_height)
	terrain_block_instance.position.x = x_offset
	terrain_block_instance.position.y = terrain_bottom_limit
	add_child(terrain_block_instance)
	
	last_spawned_terrain_block += terrain_block_width
