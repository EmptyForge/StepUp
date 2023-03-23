extends VBoxContainer

@onready var texrect : TextureRect = $TextureRect
@onready var label : Label = $Label

var texture
var prompt
var answer
var showing_prompt : bool = false

func load_content(question : Dictionary):
	var img = Image.new()
	var err = img.load(question.img_path)
	if err == OK:
		texture = ImageTexture.new()
		texrect.texture = texture.create_from_image(img)
	else:
		print("Error loading image: "+str(err))
	prompt = question.prompt
	answer = question.answer
	toggle()

func toggle():
	if showing_prompt:
		label.text = "A: " + str(answer)
	else:
		label.text = "Q: " + str(prompt)
	showing_prompt = not showing_prompt
