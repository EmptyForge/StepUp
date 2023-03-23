extends Resource
class_name QuestionDB

var questions : Array
var index : int = -1
var count : int = 0

func parse(json_string):
	questions = JSON.parse_string(json_string).questions
	count = questions.size()
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
	else:
		return null

func get_prev():
	if index > 0:
		index -= 1
		var prev_question = questions[index]
		return prev_question
	else:
		return null

func update_question_success(new_rate : float):
	var avgd_rate = (questions[index].success + new_rate) / 2.0
	questions[index].success = avgd_rate
	return avgd_rate

func save_questions(question_file_path : String):
	var new_db = {"questions": questions}
	var new_db_json = JSON.stringify(new_db)
	var new_file_path = question_file_path.replace(".json", "_new.json")
	var new_file = FileAccess.open(new_file_path, FileAccess.WRITE)
	new_file.store_string(new_db_json)
	
