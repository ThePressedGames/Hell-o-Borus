class_name GameScene
extends Node2D

signal speed_modifier_update

var score
var speed_modifier:float = 1
@export var speed_modifier_interval:int = 10
@export var speed_modifier_increase:float = 0.1

func _ready():
	score = 0

	# TODO: Questo rimanda ad una scena particolare quando chiudi la leaderboard, mandare a main menu
	#SilentWolf.configure_scores({
		#"open_scene_on_close": "res://scenes/MainPage.tscn"
	#})
	#$ScoreTimer.start()


func _game_over():
	#$ScoreTimer.stop()
	$HUD.show_game_over_message()


func _on_score_timer_timeout():
	#score += 1
	#$HUD.update_score(score)
	pass


func _on_player_score_distance_up():
	score += 1
	$HUD.update_score(score)
	
	if (score % speed_modifier_interval) == 0:
		speed_modifier += speed_modifier_increase
		speed_modifier_update.emit(speed_modifier)
	
