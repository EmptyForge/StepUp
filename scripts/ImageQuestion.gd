extends VBoxContainer

@onready var texrect : TextureRect = $TextureRect
@onready var label : Label = $Label

var img
var prompt
var answer
var showing_prompt : bool = false

func load_content(question : Dictionary):
	var img_path = question.img_path
	img = load(img_path)
	texrect.texture = img
	prompt = question.prompt
	answer = question.answer
	toggle()

func toggle():
	if showing_prompt:
		label.text = str(answer)
	else:
		label.text = str(prompt)
	showing_prompt = not showing_prompt
