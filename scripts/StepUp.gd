extends Control
class_name StepUp

const PORT = 6288

@onready var main_menu = $CanvasLayer/MainMenu
@onready var join_button = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/JoinButton
@onready var connection_address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionLineEdit
@onready var connection_status_label = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionStatusLabel

@onready var game_client = $CanvasLayer/MultiplayerSpawnRoot/GameClient
@onready var player_container = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/VBoxContainer/PlayerContainer
@onready var scoreboard = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/Scoreboard
@onready var host_options = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/HostOptions

var PlayerPanel = preload("res://scenes/PlayerPanel.tscn")

var question_db : QuestionDB
var current_question
var score_data

var enet_peer = ENetMultiplayerPeer.new()
var host_id

func _ready():
	question_db = QuestionDB.new()
	score_data = {}

func _on_host_button_pressed():
	enet_peer.create_server(PORT)
	if enet_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		multiplayer.multiplayer_peer = enet_peer
		multiplayer.peer_connected.connect(  # Connect "peer_connected" signal to add_player()
			func(new_peer_id):
				await get_tree().create_timer(1).timeout
				add_player.rpc(new_peer_id)
		)
		multiplayer.peer_disconnected.connect(
			func(new_peer_id):
				await get_tree().create_timer(1).timeout
				remove_player.rpc(new_peer_id)
		)
		host_options.activate_buttons()
		main_menu.hide()
		game_client.show()
		add_host(multiplayer.get_unique_id())

func _on_join_button_pressed():
	enet_peer.create_client(connection_address_line_edit.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_host(peer_id:int):
	host_options.read_question_file_button.disabled = false
	host_id = multiplayer.get_unique_id()

@rpc("any_peer", "call_local", "reliable")
func add_player(peer_id:int):
	main_menu.hide()
	game_client.show()
	var player_panel = PlayerPanel.instantiate()
	player_panel.name = str(peer_id)
	player_container.add_child(player_panel)

@rpc("any_peer", "call_local", "reliable")
func remove_player(peer_id:int):
	for player_panel in player_container.get_children():
		if player_panel.name == str(peer_id):
			score_data.erase(player_panel.player_name)
			player_panel.queue_free()

func update_score_data(player_name, player_score):
	score_data[player_name] = player_score
	update_scoreboard()

@rpc("any_peer", "call_local", "reliable")
func update_scoreboard():
	scoreboard.update_score.rpc(score_data)

func parse_question_file(question_file_path : String):
	var q_file = FileAccess.open(question_file_path, FileAccess.READ)
	if q_file:
		var q_file_content = q_file.get_as_text()
		question_db.parse(q_file_content)
		question_db.sort_questions()
		show_next_question()
		return OK
	else: 
		return "Error: Bad Path"

func show_hide_answer():
	game_client.toggle_question.rpc()

func show_next_question():
	current_question = question_db.get_next()
	if current_question:
		game_client.load_question.rpc(current_question, question_db.index)
	unlock_submit_buttons()

func show_prev_question():
	current_question = question_db.get_prev()
	if current_question:
		game_client.load_question.rpc(current_question, question_db.index)
	unlock_submit_buttons()

func unlock_submit_buttons():
	for player in player_container.get_children():
		player.unlock_submit_button.rpc()

func save_game(question_file_path : String):
	question_db.save_questions(question_file_path)
