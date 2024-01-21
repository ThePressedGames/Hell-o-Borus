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
	
func testino_pane_vino():
	print("TEST")
	# Load the board entry scene
	var board_entry = load("res://Scenes/PrototypeScenes/BoardEntry.tscn")

	#await %ScorePanel/ScrollContainer/PlayersList.ready
	# Create a new instance of the board entry scene
	var new_board_entry = board_entry.instantiate()

	# Set the text of the labels in the board entry scene
	new_board_entry.get_node("NameLabel").text = "Player Name"
	new_board_entry.get_node("ScoreLabel").text = "100"

	# Add the new board entry to the playerslist container
	%ScorePanel.add_child(new_board_entry)
	#var button_pck = preload("res://Scenes/PrototypeScenes/BoardEntry.tscn")
	#var button = button_pck.instance()
	#$ScorePanel/ScrollContainer/PlayersList.add_child(button)

func save_score_lw():
	# TODO: get name
	var player_name = $LineEdit.text
	# If not empty (other sanitization are handled by LineEdit
	if player_name != "":
		var score = int($ScoreValue.text)
		# var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
		# print("Score persisted successfully: " + str(sw_result.score_id))
		# SilentWolf.Scores.wipe_leaderboard()
		
		print(player_name)
		print(score)
		$LineEdit.hide()
		$ScorePanel.show()

		# SilentWolf.Scores.wipe_leaderboard()

