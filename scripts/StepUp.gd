extends Control

@onready var main_menu = $CanvasLayer/MainMenu
@onready var connection_address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ConnectionLineEdit

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
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)  # Connect "peer_connected" signal to add_player()
	
	add_player(multiplayer.get_unique_id(), true)

func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func add_player(peer_id:int, host:bool=false):
	pass
