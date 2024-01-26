extends AnimatedSprite2D

@export var intro_sfx: Array[AudioStreamWAV]
@export var shake_amplitude = 0.5
@export var random_shake_strenght: float = 30.0
@export var shake_decay_rate: float = 5.0

var current_frame: int = 0
var rand
var shake_strenght: float = 0.0


func _ready():
	rand = RandomNumberGenerator.new()
	rand.randomize()
	$FrameChangeTimer.start()


func _on_frame_change_timer_timeout():
	print("Frame change timeout!")
	
	# Go to next frame
	current_frame += 1
	
	if current_frame < 9:
		frame = current_frame
		
		# Play sfx
		var current_sfx = intro_sfx[current_frame -1]
		$AudioStreamPlayer.stream = current_sfx
		$AudioStreamPlayer.play()
		
		shake_strenght = random_shake_strenght
	elif current_frame == 10:
		Music.play()
		get_tree().change_scene_to_file("res://Scenes/Prototype/main_menu.tscn")
	


func _process(delta):
	shake_strenght = lerp(shake_strenght, 0.0, shake_decay_rate * delta)
	$Camera2D.offset = get_random_offset()


func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strenght, shake_strenght),
		rand.randf_range(-shake_strenght, shake_strenght)
	)


