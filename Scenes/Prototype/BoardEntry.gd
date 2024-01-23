extends HBoxContainer

var player_name = "PLACEHOLDER"
var player_score = "0000"

@onready var name_label = $NameLabel
@onready var score_label = $ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels(player_name, player_score)


func update_labels(name: String, score: String):
	name_label.text = "%s" % name
	score_label.text = "%s" % score
