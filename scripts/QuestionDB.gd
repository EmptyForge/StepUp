extends Resource
class_name QuestionDB

var questions : Array
var index : int = -1

func parse(json_string):
	questions = JSON.parse_string(json_string).questions
	shuffle_questions()
	sort_questions()

# Fisher-Yates shuffle
func shuffle_questions():
	var pos = 0
	while pos < questions.size()-1:
		var swap = randi_range(0, questions.size()-1)
		var temp = questions[pos]
		questions[pos] = questions[swap]
		questions[swap] = temp
		pos += 1

# Gnomesort
# Sort questions by success ratio
func sort_questions():
	var pos = 0
	while pos < questions.size():
		if (pos == 0 or questions[pos].success >= questions[pos-1].success):
			pos += 1
		else:
			var temp = questions[pos]
			questions[pos] = questions[pos-1]
			questions[pos-1] = temp
			pos -= 1

func get_next():
	if index < questions.size()-1:
		index += 1
		var next_question = questions[index]
		return next_question

func get_prev():
	if index > 0:
		index -= 1
		var prev_question = questions[index]
		return prev_question
	else:
		return null
