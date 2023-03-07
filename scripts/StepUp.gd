extends Control
class_name StepUp

const PORT = 6288

@onready var main_menu = $CanvasLayer/MainMenu
@onready var connection_address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionLineEdit
@onready var connection_status_label = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionStatusLabel

@onready var game_client = $CanvasLayer/MultiplayerSpawnRoot/GameClient
@onready var player_container = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/VBoxContainer/PlayerContainer
@onready var scoreboard = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/Scoreboard
@onready var host_options = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/HostOptions

var PlayerPanel = preload("res://scenes/PlayerPanel.tscn")

var question_db : QuestionDB
var current_question

var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	question_db = QuestionDB.new()

func _on_host_button_pressed():
	var rc = enet_peer.create_server(PORT)
	if rc == OK:
		multiplayer.multiplayer_peer = enet_peer
		multiplayer.peer_connected.connect(add_player)  # Connect "peer_connected" signal to add_player()
		host_options.activate_buttons()
		main_menu.hide()
		game_client.show()
		add_host(multiplayer.get_unique_id())

func _on_join_button_pressed():
	var rc = enet_peer.create_client("localhost", PORT) # rc contains the return code for this peer
	if rc == OK:
		multiplayer.multiplayer_peer = enet_peer
		main_menu.hide()
		game_client.show()
	else:
		connection_status_label.text = "Error while trying to connect to server. Error code: " + str(rc)

func add_host(peer_id:int):
	host_options.read_question_file_button.disabled = false
	
func add_player(peer_id:int):
	var player_panel = PlayerPanel.instantiate()
	player_panel.name = str(peer_id)
	player_container.add_child(player_panel)

@rpc("any_peer")
func update_scoreboard():
	var score_data = {}
	for player in player_container.get_children():
		score_data[player.player_name] = player.player_score
	scoreboard.update_score(score_data)

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

# These are kinda nasty and don't work well
func show_next_question():
	current_question = question_db.get_next()
	if current_question:
		game_client.load_question.rpc(current_question, question_db.index)

func show_prev_question():
	current_question = question_db.get_prev()
	if current_question:
		game_client.load_question.rpc(current_question, question_db.index)
