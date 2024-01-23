extends CanvasLayer


func _ready():
	$GameOverLabel.hide()
	$LineEdit.hide()
	$ScorePanel.hide()

func update_score(score: int):
	$ScoreValue.text = str(score)
	

func show_game_over_message():
	$GameOverLabel.show()
	$LineEdit.show()
	
func _testino_pane_vino():
	print("TEST")
	SilentWolf.Scores.wipe_leaderboard()
	# Load the board entry scene
	#var board_entry = load("res://Scenes/BoardEntry.tscn")
#	##await %ScorePanel/ScrollContainer/PlayersList.ready
	## Create a new instance of the board entry scene
	#var new_board_entry = board_entry.instantiate()
#
	## Set the text of the labels in the board entry scene
	#new_board_entry.get_node("NameLabel").text = "Player Name"
	#new_board_entry.get_node("ScoreLabel").text = "100"

	# Add the new board entry to the playerslist container
	#%ScorePanel.hide()
	#var button_pck = preload("res://Scenes/PrototypeScenes/BoardEntry.tscn")
	#var button = button_pck.instance()
	#$ScorePanel/ScrollContainer/PlayersList.add_child(button)

func save_score_lw():
	var player_name = $LineEdit.text
	# If not empty (other sanitization are handled by LineEdit
	if player_name != "":
		var score = int($ScoreValue.text)
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


