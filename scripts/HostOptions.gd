extends PanelContainer
class_name HostOptions

@onready var step_up : StepUp = get_node("/root/StepUp")
@onready var address_label : Label = $MarginContainer/VBoxContainer/AddressLabel
@onready var read_question_file_button : Button = $MarginContainer/VBoxContainer/Options/ReadQuestionFileButton
@onready var show_hide_question_button : Button = $MarginContainer/VBoxContainer/Options/RevealAnswerButton
@onready var next_question_button : Button = $MarginContainer/VBoxContainer/Options/NextQuestionButton
@onready var prev_question_button : Button = $MarginContainer/VBoxContainer/Options/PrevQuestionButton
@onready var reveal_answers_button : Button = $MarginContainer/VBoxContainer/Options/RevealAnswersButton

const QUESTION_FILE_PATH = "res://assets/test_questions/questions_real.json"

func _ready():
	read_question_file_button.disabled = true
	show_hide_question_button.disabled = true
	next_question_button.disabled = true
	prev_question_button.disabled = true
	reveal_answers_button.disabled = true

func activate_buttons():
	show_hide_question_button.disabled = false
	next_question_button.disabled = false
	prev_question_button.disabled = false
	reveal_answers_button.disabled = false
	

func _on_read_question_file_button_pressed():
	var err = step_up.parse_question_file(QUESTION_FILE_PATH)
	if err == OK:
		read_question_file_button.text = "Questions Ready!"
	else:
		read_question_file_button.text = "Error"


func _on_reveal_answer_button_pressed():
	step_up.show_hide_answer()


func _on_next_question_button_pressed():
	step_up.show_next_question()


func _on_prev_question_button_pressed():
	step_up.show_prev_question()

func _on_reveal_answers_button_pressed():
	step_up.reveal_all_answers()
