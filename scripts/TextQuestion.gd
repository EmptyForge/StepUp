extends RichTextLabel

var prompt
var answer
var showing_prompt : bool = false

func load_content(question : Dictionary):
	prompt = question.prompt
	answer = question.answer
	toggle()

func toggle():
	if showing_prompt:
		self.text = "[center]" + str(answer)
	else:
		self.text = "[center]" + str(prompt)
	showing_prompt = not showing_prompt
