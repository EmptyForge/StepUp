extends Control
class_name StepUp

const PORT = 6288

@onready var main_menu = $CanvasLayer/MainMenu
@onready var connection_address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionLineEdit
@onready var connection_status_label = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionStatusLabel

@onready var game_client = $CanvasLayer/MultiplayerSpawnRoot/GameClient
@onready var player_container = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/VBoxContainer/PlayerContainer
@onready var scoreboard = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/Scoreboard

var PlayerPanel = preload("res://scenes/PlayerPanel.tscn")

var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_host_button_pressed():	
	var rc = enet_peer.create_server(PORT)
	if rc == OK:
		multiplayer.multiplayer_peer = enet_peer
		multiplayer.peer_connected.connect(add_player)  # Connect "peer_connected" signal to add_player()
		
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
	pass
	
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
