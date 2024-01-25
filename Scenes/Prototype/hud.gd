extends CanvasLayer


func _ready():
	$GameOverLabel.hide()
	$LineEdit.hide()
	$ScorePanel.hide()
	$RetryButton.hide()
	$BackButton.hide()

func update_score(score: int):
	$ScoreContainer/ScoreValue.text = str(score)
	

func show_game_over_message():
	$GameOverLabel.show()
	$LineEdit.show()
	$RetryButton.show()
	$BackButton.show()
	#
#func _testino_pane_vino():
	#print("TEST")
	#SilentWolf.Scores.wipe_leaderboard()


func save_score_lw():
	var player_name = $LineEdit.text
	# If not empty (other sanitization are handled by LineEdit
	if player_name != "":
		var score = int($ScoreContainer/ScoreValue.text)
		var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
		#print("Score persisted successfully: " + str(sw_result.score_id))

		$LineEdit.hide()
		# Load the board entry scene				
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
			$ScorePanel/ScrollContainer/PlayersList.add_child(new_board_entry)
			new_board_entry.update_labels(p_name, str(p_score))
		$ScorePanel.show()




func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Prototype/ProceduralGeneration/game_scene.tscn")
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Prototype/main_menu.tscn")
