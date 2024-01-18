@tool
extends Node2D

@export var player: Player

# Ground blocks variables
var terrain_bottom_limit = 800
var terrain_block: PackedScene = preload("res://Scenes/PrototypeScenes/ProceduralGeneration/terrain_block.tscn")
@export var terrain_block_width = 800
@export var terrain_block_height = 50
var last_spawned_terrain_block = 0

# Background elements variables
var background_element: PackedScene = preload("res://Scenes/PrototypeScenes/ProceduralGeneration/background_element.tscn")
var last_spawned_element_offset = 0

# @export var obstacle: PackedScene


func _process(delta):
	var player_x = player.global_position.x
	
	# Spawn ground blocks
	if player_x > last_spawned_terrain_block - terrain_block_width:
		spawn_terrain_block(last_spawned_terrain_block)
	
	# Spawn background elements
	if player_x > last_spawned_element_offset - terrain_block_width:
		spawn_background_element(last_spawned_element_offset)


func spawn_terrain_block(x_offset: float):
	var terrain_block_instance = terrain_block.instantiate()
	terrain_block_instance.spawn_block(terrain_block_width, terrain_block_height)
	terrain_block_instance.position.x = x_offset
	terrain_block_instance.position.y = terrain_bottom_limit
	add_child(terrain_block_instance)
	
	last_spawned_terrain_block += terrain_block_width


func spawn_background_element(x_offset: float):
	var background_element_instance = background_element.instantiate()
	background_element_instance.calculate_position(x_offset)
	add_child(background_element_instance)
	
	last_spawned_element_offset = background_element_instance.calculate_next_offset(last_spawned_element_offset)
