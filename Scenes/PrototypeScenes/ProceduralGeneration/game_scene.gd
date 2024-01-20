extends Node2D

var score


func _ready():
	score = 0
	$ScoreTimer.start()


func game_over():
	$ScoreTimer.stop()
	#$HUD.show_game_over_message(score)


func _on_score_timer_timeout():
	score += 1
	#print(score)
	$HUD.update_score(score)
