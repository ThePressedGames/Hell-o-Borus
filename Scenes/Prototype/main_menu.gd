extends Control


func _ready():
	SilentWolf.configure({
		"api_key": "lb6MlBbxsM5CkXwPi710p7pCzWeDVExd3TIjymaa",
		"game_id": "Hell-o-borus",
		"game_version": "0.1",
		"log_level": 0
	})
	
	$LeaderboardPanel.hide()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Prototype/ProceduralGeneration/game_scene.tscn")


func _on_leaderboard_button_pressed():
	var board_entry = preload("res://Scenes/Prototype/BoardEntry.tscn")
	var scores: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	# LOAD SCORES
	for sc in scores["scores"]:
		## Create a new instance of the board entry scene
		var new_board_entry = board_entry.instantiate()
		var p_name = sc["player_name"]
		var p_score = sc["score"]

		## Set the text of the labels in the board entry scene
		#new_board_entry.update_labels(p_name, str(p_score))
		#new_board_entry.name_label = p_name
		#new_board_entry.score_label = str(p_score)

		## Add the new board entry to the playerslist container
		$LeaderboardPanel/ScrollContainer/PlayersList.add_child(new_board_entry)
		new_board_entry.update_labels(p_name, str(p_score))
	$LeaderboardPanel.show()


func _on_leaderboard_close_button_pressed():
	$LeaderboardPanel.hide()
