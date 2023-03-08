extends PanelContainer
class_name PlayerPanel

const player_panel_stylebox = preload("res://assets/theme/player_panel_stylebox.tres")

@onready var player_inputs = $MarginContainer/PlayerInputs
@onready var player_name_label = $MarginContainer/PlayerInputs/NameLabel
@onready var player_text_entry = $MarginContainer/PlayerInputs/AnswerTextEdit
@onready var player_submit_button = $MarginContainer/PlayerInputs/SubmitButton
@onready var player_status_label = $MarginContainer/PlayerInputs/StatusLabel

@onready var player_customizer = $MarginContainer/PlayerCustomization
@onready var player_name_edit = $MarginContainer/PlayerCustomization/NameLineEdit
@onready var player_colorpicker = $MarginContainer/PlayerCustomization/ColorPickerButton
@onready var player_custom_submit = $MarginContainer/PlayerCustomization/CustomizationSubmitButton

@onready var host_buttons = $HostButtons

@onready var step_up : StepUp = get_node("/root/StepUp")
@onready var synchronizer = $MultiplayerSynchronizer

@export var player_name : String = "PlayerName"
@export var player_color : Color = Color.DIM_GRAY
@export var player_status : String = "Hello!"
@export var player_answer : String = "..."
var player_score : int = 0

# Called when this instance of the scene enters the scene tree for the first time,
# like when it's spawned by the multiplayer server
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

# Called when the node enters the scene tree and is ready
func _ready():
	if not is_multiplayer_authority():
		player_text_entry.hide()
		player_submit_button.hide()
		player_status_label.show()
		if multiplayer.get_unique_id() == step_up.host_id:
			host_buttons.show()
	else:
		player_inputs.hide()
		player_customizer.show()
		
func _on_submit_button_pressed():
	player_status = "Submitted!"
	player_answer = player_text_entry.text
	player_submit_button.disabled = true

@rpc("any_peer", "call_local", "reliable")
func unlock_submit_button():
	player_submit_button.disabled = false
	player_status = "Ready!"

func _on_customization_submit_button_pressed():
	player_name = player_name_edit.text
	player_color = player_colorpicker.color
	player_status = "Ready!"
	player_customizer.hide()
	player_inputs.show()
	step_up.update_scoreboard.rpc()

@rpc("any_peer", "call_local", "reliable")
func update_visuals():
	player_name_label.text = player_name
	player_status_label.text = player_status
	if player_color != self.get_theme_stylebox("panel").bg_color:
		var new_stylebox = player_panel_stylebox.duplicate()
		new_stylebox.bg_color = player_color
		self.add_theme_stylebox_override("panel", new_stylebox)
	#print("update_visuals() on Peer " + name + " from Peer " + str(multiplayer.multiplayer_peer.get_unique_id()))
	#print("player_name: " + player_name + ", player_status " + player_status + ", player_score: " + str(player_score))

func _on_add_point_button_pressed():
	player_score += 1
	step_up.update_score_data(player_name, player_score)

func _on_subtract_point_button_pressed():
	player_score -= 1
	step_up.update_score_data(player_name, player_score)

func _on_show_answer_button_pressed():
	show_answer.rpc()
# These two functions above and below show how you can trigger a function on a multiplayer authority from the server
@rpc("any_peer", "call_local", "reliable")
func show_answer():
	player_status = player_answer

func _on_multiplayer_synchronizer_synchronized():
	update_visuals.rpc()
