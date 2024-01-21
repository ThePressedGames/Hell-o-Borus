extends CanvasLayer


func _ready():
	$GameOverLabel.hide()


func update_score(score: int):
	$ScoreValue.text = str(score)
