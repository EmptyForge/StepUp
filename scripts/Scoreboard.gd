extends PanelContainer
class_name Scoreboard

@onready var player_scores_container = $MarginContainer/VBoxContainer/PlayerScores

var PlayerScoreCard = preload("res://scenes/PlayerScoreCard.tscn")

var players_on_board = Array()

@rpc("any_peer", "call_local", "reliable")
func update_score(score_data):
	for player in score_data:
		if player == "PlayerName":
			pass
		elif player not in players_on_board:
			var new_player_card = PlayerScoreCard.instantiate()
			player_scores_container.add_child(new_player_card)
			players_on_board.append(player)
			new_player_card.player_name = player
			new_player_card.player_score = score_data[player]
			new_player_card.update_card()
		else:
			for card in player_scores_container.get_children():
				if card.player_name == player:
					card.player_score = score_data[player]
					card.update_card()
