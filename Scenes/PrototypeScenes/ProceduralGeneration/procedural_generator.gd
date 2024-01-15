# @tool
extends Node2D

# Bottom limit to instantiate ground tiles in px
const GROUND_BOTTOM_LIMIT = 640
# Tile size in px
const TILE_SIZE = 128

@export var player: Player

@export_group("Tiles", "tile_")
@export var ground_tile: PackedScene

var instantiated_tiles: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Loop to instantiate all tiles
	for i in range(-4, 8) : # Range values HARDCODED
		var tile = ground_tile.instantiate()
		
		# Calculate and set tile position
		var tile_position = Vector2(player.position.x + (i * TILE_SIZE), GROUND_BOTTOM_LIMIT)
		tile.position = tile_position
		
		print("Instantiating tile in position " + str(tile.position))
		
		# Spawn tile
		add_child(tile)
		
		instantiated_tiles.append(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# func _on_player_player_moved_right():
# 	pass # Replace with function body.
