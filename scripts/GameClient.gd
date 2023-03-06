extends PanelContainer
class_name GameClient

@onready var content_container = $MarginContainer/VBoxContainer/ContentPanel/MarginContainer

var TextQuestion = preload("res://scenes/TextQuestion.tscn")
var ImageQuestion = preload("res://scenes/ImageQuestion.tscn")

@export var question_dir : String

@rpc("any_peer")
func load_question():
	pass
