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
var background_element_tree: PackedScene = preload("res://Scenes/PrototypeScenes/ProceduralGeneration/background_element_tree.tscn")
var background_element_rock: PackedScene = preload("res://Scenes/PrototypeScenes/ProceduralGeneration/background_element_rock.tscn")
@export_group("Background elements")
@export_subgroup("Parallax layer VERY FAR", "very_far_")
@export var very_far_parallax_layer: ParallaxLayer
@export var very_far_layer_offset_y = 450
@export var very_far_layer_min_spacing_x = 200
@export var very_far_layer_max_spacing_x = 500
var last_spawned_element_very_far_offset_x: int = 0
@export_subgroup("Parallax layer FAR", "far_")
@export var far_parallax_layer: ParallaxLayer
@export var far_layer_offset_y = 450
@export var far_layer_min_spacing_x = 100
@export var far_layer_max_spacing_x = 400
var last_spawned_element_far_offset_x: int = 0
@export_subgroup("Parallax layer CLOSE", "close_")
@export var close_parallax_layer: ParallaxLayer
@export var close_layer_offset_y = 400
@export var close_layer_min_spacing_x = 300
@export var close_layer_max_spacing_x = 700
var last_spawned_element_close_offset_x: int = 0
@export_subgroup("Parallax layer VERY CLOSE", "very_close_")
@export var very_close_parallax_layer: ParallaxLayer
@export var very_close_layer_offset_y = 400
@export var very_close_layer_min_spacing_x = 150
@export var very_close_layer_max_spacing_x = 500
var last_spawned_element_very_close_offset_x: int = 0
@export_subgroup("Parallax layer FRONT", "front_")
@export var front_parallax_layer: ParallaxLayer
@export var front_layer_offset_y = 400
@export var front_layer_min_spacing_x = 400
@export var front_layer_max_spacing_x = 900
var last_spawned_element_front_offset_x: int = 0

# Obstacles variables
@export_group("Obstacles", "obstacles_")
@export var obstacles_ground: Array[PackedScene]
@export var obstacles_min_spawn_interval: float = 0.5
@export var obstacles_max_spawn_interval: float = 2


func _ready():
	$ObstacleSpawnTimer.wait_time = obstacles_min_spawn_interval
	$ObstacleSpawnTimer.start()


func _process(_delta):
	var player_x = player.global_position.x
	
	# Spawn ground blocks
	if player_x > last_spawned_terrain_block - terrain_block_width:
		spawn_terrain_block(last_spawned_terrain_block)
	
	# Spawn background elements
	spawn_background_elements(player_x)


func spawn_terrain_block(x_offset: float):
	var terrain_block_instance = terrain_block.instantiate()
	terrain_block_instance.spawn_block(terrain_block_width, terrain_block_height)
	terrain_block_instance.position.x = x_offset
	terrain_block_instance.position.y = terrain_bottom_limit
	add_child(terrain_block_instance)
	
	last_spawned_terrain_block += terrain_block_width


func spawn_background_elements(player_x: float):
	# Very far layer
	if player_x > last_spawned_element_very_far_offset_x - terrain_block_width:
		var element = spawn_background_element_rock(very_far_parallax_layer, last_spawned_element_very_far_offset_x, very_far_layer_offset_y)
		last_spawned_element_very_far_offset_x = element.calculate_next_offset(last_spawned_element_very_far_offset_x, very_far_layer_min_spacing_x, very_far_layer_max_spacing_x)
	# Far layer
	if player_x > last_spawned_element_far_offset_x - terrain_block_width:
		var element = spawn_background_element_tree(far_parallax_layer, last_spawned_element_far_offset_x, far_layer_offset_y)
		last_spawned_element_far_offset_x = element.calculate_next_offset(last_spawned_element_far_offset_x, far_layer_min_spacing_x, far_layer_max_spacing_x)
	# Close layer
	if player_x > last_spawned_element_close_offset_x - terrain_block_width:
		var element = spawn_background_element_tree(close_parallax_layer, last_spawned_element_close_offset_x, close_layer_offset_y)
		last_spawned_element_close_offset_x = element.calculate_next_offset(last_spawned_element_close_offset_x, close_layer_min_spacing_x, close_layer_max_spacing_x)
	# Very close layer
	if player_x > last_spawned_element_very_close_offset_x - terrain_block_width:
		var element = spawn_background_element_tree(very_close_parallax_layer, last_spawned_element_very_close_offset_x, very_close_layer_offset_y)
		last_spawned_element_very_close_offset_x = element.calculate_next_offset(last_spawned_element_very_close_offset_x, very_close_layer_min_spacing_x, very_close_layer_max_spacing_x)
	# Front layer
	if player_x > last_spawned_element_front_offset_x - terrain_block_width:
		var element = spawn_background_element_tree(front_parallax_layer, last_spawned_element_front_offset_x, front_layer_offset_y)
		last_spawned_element_front_offset_x = element.calculate_next_offset(last_spawned_element_front_offset_x, front_layer_min_spacing_x, front_layer_max_spacing_x)

func spawn_background_element_rock(layer: ParallaxLayer, x_offset: float, y_offset: float):
	var background_element_rock_instance = background_element_rock.instantiate()
	background_element_rock_instance.update_position(x_offset, y_offset)
	layer.add_child(background_element_rock_instance)
	return background_element_rock_instance

func spawn_background_element_tree(layer: ParallaxLayer, x_offset: float, y_offset: float):
	var background_element_tree_instance = background_element_tree.instantiate()
	background_element_tree_instance.update_position(x_offset, y_offset)
	layer.add_child(background_element_tree_instance)
	return background_element_tree_instance


func _on_obstacle_spawn_timer_timeout():
	var obstacle_scene = obstacles_ground.pick_random()
	var obstacle_instance = obstacle_scene.instantiate()
	
	var new_scale = randf_range(0.5, 1.5)
	obstacle_instance.scale = Vector2(new_scale, new_scale)
	
	obstacle_instance.position.x = player.global_position.x + 1500
	obstacle_instance.position.y = 600 + (50/obstacle_instance.scale.x)
	print(str(obstacle_instance.position))
	add_child(obstacle_instance)
	$ObstacleSpawnTimer.wait_time = randf_range(obstacles_min_spawn_interval, obstacles_max_spawn_interval)
