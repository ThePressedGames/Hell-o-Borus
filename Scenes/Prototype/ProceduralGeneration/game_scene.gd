extends Node2D

var score

func _ready():
	score = 0
	SilentWolf.configure({
		"api_key": "lb6MlBbxsM5CkXwPi710p7pCzWeDVExd3TIjymaa",
		"game_id": "Hell-o-borus",
		"game_version": "0.1",
		"log_level": 0
	})

	# TODO: Questo rimanda ad una scena particolare quando chiudi la leaderboard, mandare a main menu
	#SilentWolf.configure_scores({
		#"open_scene_on_close": "res://scenes/MainPage.tscn"
	#})
	$ScoreTimer.start()

func _game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over_message()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
