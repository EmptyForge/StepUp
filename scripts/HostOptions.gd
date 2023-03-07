extends PanelContainer
class_name HostOptions

@onready var step_up : StepUp = get_node("/root/StepUp")
@onready var question_file_line_edit : LineEdit = $MarginContainer/VBoxContainer/Options/QuestionFilePathLineEdit
@onready var read_question_file_button : Button = $MarginContainer/VBoxContainer/Options/ReadQuestionFileButton
@onready var show_hide_question_button : Button = $MarginContainer/VBoxContainer/Options/RevealAnswerButton
@onready var next_question_button : Button = $MarginContainer/VBoxContainer/Options/NextQuestionButton
@onready var prev_question_button : Button = $MarginContainer/VBoxContainer/Options/PrevQuestionButton

func _ready():
	read_question_file_button.disabled = true
	show_hide_question_button.disabled = true
	next_question_button.disabled = true
	prev_question_button.disabled = true

func activate_buttons():
	show_hide_question_button.disabled = false
	next_question_button.disabled = false
	prev_question_button.disabled = false

func _on_read_question_file_button_pressed():
	var err = step_up.parse_question_file(question_file_line_edit.text)
	if err == OK:
		question_file_line_edit.text = "Questions Ready!"
	else:
		question_file_line_edit.text = err


func _on_reveal_answer_button_pressed():
	step_up.show_hide_answer()


func _on_next_question_button_pressed():
	step_up.show_next_question()


func _on_prev_question_button_pressed():
	step_up.show_prev_question()
