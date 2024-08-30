extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func type_in_question_linedit(number: String):
	var QuestionLineEdit: LineEdit = get_node("%QuestionLineEdit")
	if number == "backspace":
		QuestionLineEdit.text = QuestionLineEdit.text.substr(0, len(QuestionLineEdit.text) - 1)
	else:
		QuestionLineEdit.text += number
