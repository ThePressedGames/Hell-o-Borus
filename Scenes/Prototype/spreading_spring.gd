extends LethalObstacle


@export var speed:int = 800


func _ready():
	$AnimatedSprite2D.play()

func _process(delta):
	position.x = position.x + (delta * speed)


func _on_player_hit():
	speed = 0
