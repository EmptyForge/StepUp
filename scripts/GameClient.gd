extends PanelContainer
class_name GameClient

@onready var content_container = $MarginContainer/VBoxContainer/ContentPanel/MarginContainer
@onready var question_number_label = $MarginContainer/VBoxContainer/ContentPanel/QuestionNumberLabel

var TextQuestion = preload("res://scenes/TextQuestion.tscn")
var ImageQuestion = preload("res://scenes/ImageQuestion.tscn")

@export var question_dir : String

@rpc("any_peer", "call_local")
func load_question(question : Dictionary, question_number : int):
	var old_content = content_container.get_child(0)
	if old_content:
		old_content.queue_free()
	var new_question_content
	if question.category == "image":
		new_question_content = ImageQuestion.instantiate()
	else:
		new_question_content = TextQuestion.instantiate()
	content_container.add_child(new_question_content)
	new_question_content.load_content(question)
	question_number_label.text = str(question_number)

@rpc("any_peer", "call_local")
func toggle_question():
	var content = content_container.get_child(0)
	if content:
		content.toggle()

