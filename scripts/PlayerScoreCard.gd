extends HBoxContainer
class_name PlayerScoreCard

@onready var player_name_label = $PlayerName
@onready var score_label = $Score

var player_name : String = "PlayerName"
var player_score : int = KEY_0

func update_card():
	player_name_label.text = player_name
	score_label.text = str(player_score)
