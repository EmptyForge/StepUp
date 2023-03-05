extends Control

@onready var main_menu = $CanvasLayer/MainMenu
@onready var connection_address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionLineEdit
@onready var game_client = $CanvasLayer/MultiplayerSpawnRoot/GameClient
@onready var player_container = $CanvasLayer/MultiplayerSpawnRoot/GameClient/MarginContainer/VBoxContainer/PlayerContainer

var PlayerPanel = preload("res://scenes/PlayerPanel.tscn")

const PORT = 6288

var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	# Initialize the server with
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_host_button_pressed():
	main_menu.hide()
	game_client.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)  # Connect "peer_connected" signal to add_player()
	
	add_host(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	game_client.show()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_host(peer_id:int):
	pass
	
func add_player(peer_id:int):
	var player_panel = PlayerPanel.instantiate()
	player_panel.name = str(peer_id)
	player_container.add_child(player_panel)
