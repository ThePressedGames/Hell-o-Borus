@tool
extends Node2D

@export var player: Player

var difficulty_speed_modifier:float = 1

# Ground blocks variables
var terrain_bottom_limit = 800
var terrain_block: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/terrain_block.tscn")
@export var terrain_block_width = 800
@export var terrain_block_height = 50
var last_spawned_terrain_block = 0

# Background elements variables
var background_terrain_block: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/background_terrain_block.tscn")
var background_snow_pack: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/snow_pack.tscn")
var background_element_tree: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/background_element_tree.tscn")
var background_element_rock: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/background_element_rock.tscn")

# Background elements variables
#var blur_background_terrain_block: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/background_terrain_block.tscn")
#var blur_background_snow_pack: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/blur_snow_pack.tscn")
var blur_background_element_tree: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/blur_background_element_tree.tscn")
var blur_background_element_rock: PackedScene = preload("res://Scenes/Prototype/ProceduralGeneration/Background/blur_background_element_rock.tscn")

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
var last_spawned_terrain_block_far_offset_x: int = 0
@export_subgroup("Parallax layer CLOSE", "close_")
@export var close_parallax_layer: ParallaxLayer
@export var close_layer_offset_y = 400
@export var close_layer_min_spacing_x = 300
@export var close_layer_max_spacing_x = 700
var last_spawned_element_close_offset_x: int = 0
@export_subgroup("Parallax layer VERY CLOSE", "very_close_")
@export var very_close_parallax_layer_snow_packs: ParallaxLayer
@export var very_close_parallax_layer: ParallaxLayer
@export var very_close_layer_offset_y = 400
@export var very_close_layer_min_spacing_x = 150
@export var very_close_layer_max_spacing_x = 500
var last_spawned_element_very_close_offset_x: int = 0
@export_subgroup("Parallax layer FRONT", "front_")
@export var front_parallax_layer_snow_packs: ParallaxLayer
@export var front_parallax_layer: ParallaxLayer
@export var front_layer_offset_y = -980
@export var front_layer_min_spacing_x = 400
@export var front_layer_max_spacing_x = 900
var last_spawned_element_front_offset_x: int = 0
var last_spawned_terrain_block_front_offset_x: int = 0

# Obstacles variables
@export_group("Obstacles")
@export_subgroup("Rocks", "rock_obstacle_")
@export var rock_obstacle_list: Array[PackedScene]
@export var rock_obstacle_min_spawn_interval: float = 0.5
@export var rock_obstacle_max_spawn_interval: float = 2

@export_subgroup("Bird", "bird_")
@export var bird_scene: PackedScene
@export var bird_min_spawn_interval: float = 3
@export var bird_max_spawn_interval: float = 6

@export_subgroup("Hedgehog", "hedgehog_")
@export var hedgehog_scene: PackedScene
@export var hedgehog_min_spawn_interval: float = 4
@export var hedgehog_max_spawn_interval: float = 8


func _ready():
	$ObstacleSpawnTimer.wait_time = rock_obstacle_min_spawn_interval
	$ObstacleSpawnTimer.start()
	$BirdSpawnTimer.wait_time = bird_min_spawn_interval
	$BirdSpawnTimer.start()
	$HedgehogSpawnTimer.wait_time = hedgehog_min_spawn_interval
	$HedgehogSpawnTimer.start()
	
	var player_x = player.global_position.x
	for index in range(0, 10):
		spawn_snow_pack(very_close_parallax_layer_snow_packs, player_x - index * 100, 730)
		spawn_snow_pack(front_parallax_layer_snow_packs, player_x - index * 100, -705)


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
	if player_x > last_spawned_element_very_far_offset_x + 300:
		var element = spawn_background_element_rock(very_far_parallax_layer, last_spawned_element_very_far_offset_x, very_far_layer_offset_y)
		last_spawned_element_very_far_offset_x = element.calculate_next_offset(last_spawned_element_very_far_offset_x, very_far_layer_min_spacing_x, very_far_layer_max_spacing_x)
	# Far layer - terrain
	if player_x > last_spawned_terrain_block_far_offset_x - 1000:
		var block = spawn_background_terrain_block(far_parallax_layer, last_spawned_terrain_block_far_offset_x, 700)
		last_spawned_terrain_block_far_offset_x = block.position.x + 1000
	# Far layer - elements
	if player_x > last_spawned_element_far_offset_x - 1200:
		var element = spawn_background_element_tree(far_parallax_layer, last_spawned_element_far_offset_x, far_layer_offset_y)
		last_spawned_element_far_offset_x = element.calculate_next_offset(last_spawned_element_far_offset_x, far_layer_min_spacing_x, far_layer_max_spacing_x)
	# Close layer
	if player_x > last_spawned_element_close_offset_x - 300:
		var element = spawn_background_element_tree(close_parallax_layer, last_spawned_element_close_offset_x, close_layer_offset_y)
		last_spawned_element_close_offset_x = element.calculate_next_offset(last_spawned_element_close_offset_x, close_layer_min_spacing_x, close_layer_max_spacing_x)
	# Very close layer - snow packs
	spawn_snow_pack(very_close_parallax_layer_snow_packs, player_x, 730)
	# Very close layer
	if player_x > last_spawned_element_very_close_offset_x:
		var element = spawn_background_element_tree(very_close_parallax_layer, last_spawned_element_very_close_offset_x, very_close_layer_offset_y)
		last_spawned_element_very_close_offset_x = element.calculate_next_offset(last_spawned_element_very_close_offset_x, very_close_layer_min_spacing_x, very_close_layer_max_spacing_x)
	# Front layer
	if player_x > last_spawned_element_front_offset_x:
		var element = spawn_background_element_tree(front_parallax_layer, last_spawned_element_front_offset_x, front_layer_offset_y)
		last_spawned_element_front_offset_x = element.calculate_next_offset(last_spawned_element_front_offset_x, front_layer_min_spacing_x, front_layer_max_spacing_x)
		# Front layer - terrain
	#if player_x > last_spawned_terrain_block_front_offset_x:
		#var block = spawn_background_terrain_block(front_parallax_layer, last_spawned_terrain_block_front_offset_x, -460)
		#last_spawned_terrain_block_front_offset_x = block.position.x + 1000
	# Front layer - snow packs
	spawn_snow_pack(front_parallax_layer_snow_packs, player_x, -700)

func spawn_snow_pack(layer: ParallaxLayer, player_x_position: float, y_offset: float):
	var snow_pack_instance = background_snow_pack.instantiate()
	snow_pack_instance.position = Vector2(player_x_position, y_offset)
	layer.add_child(snow_pack_instance)
	layer.move_child(snow_pack_instance, 0)

func spawn_background_terrain_block(layer: ParallaxLayer, x_offset: float, y_offset):
	var background_terrain_block_instance = background_terrain_block.instantiate()
	background_terrain_block_instance.position = Vector2(x_offset, y_offset)
	layer.add_child(background_terrain_block_instance)
	layer.move_child(background_terrain_block_instance, 0)
	return background_terrain_block_instance

func spawn_background_element_rock(layer: ParallaxLayer, x_offset: float, y_offset: float):
	var background_element_rock_instance
	if layer in [very_far_parallax_layer]:
		background_element_rock_instance = blur_background_element_rock.instantiate()
	else:
		background_element_rock_instance = background_element_rock.instantiate()
	background_element_rock_instance.update_position(x_offset, y_offset)
	layer.add_child(background_element_rock_instance)
	return background_element_rock_instance

func spawn_background_element_tree(layer: ParallaxLayer, x_offset: float, y_offset: float):
	var background_element_tree_instance
	if layer in [very_far_parallax_layer, far_parallax_layer, close_parallax_layer, front_parallax_layer]:
		background_element_tree_instance = blur_background_element_tree.instantiate()
	else:
		background_element_tree_instance = background_element_tree.instantiate()
	background_element_tree_instance.update_position(x_offset, y_offset)
	layer.add_child(background_element_tree_instance)
	return background_element_tree_instance


func _on_rock_spawn_timer_timeout():
	var obstacle_scene = rock_obstacle_list.pick_random()
	var obstacle_instance = obstacle_scene.instantiate()
	
	var new_scale = randf_range(0.5, 1.5)
	obstacle_instance.scale = Vector2(new_scale, new_scale)
	
	obstacle_instance.position.x = player.global_position.x + 2000
	obstacle_instance.position.y = 600 + (50/obstacle_instance.scale.x)
	add_child(obstacle_instance)
	$ObstacleSpawnTimer.wait_time = randf_range(rock_obstacle_min_spawn_interval, rock_obstacle_max_spawn_interval)


func _on_bird_spawn_timer_timeout():
	var bird_instance = bird_scene.instantiate()
	bird_instance.position.x = player.global_position.x - 1500
	bird_instance.update_speed(difficulty_speed_modifier)
	add_child(bird_instance)
	$BirdSpawnTimer.wait_time = randf_range(bird_min_spawn_interval, bird_max_spawn_interval)


func _on_hedgehog_spawn_timer_timeout():
	var hedgehog_instance = hedgehog_scene.instantiate()
	hedgehog_instance.position.y = 650
	hedgehog_instance.position.x = player.global_position.x + 2500
	add_child(hedgehog_instance)
	$HedgehogSpawnTimer.wait_time = randf_range(hedgehog_min_spawn_interval, hedgehog_max_spawn_interval)


func _on_main_scene_speed_modifier_update(speed_modifier: float):
	difficulty_speed_modifier = speed_modifier
