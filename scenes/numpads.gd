extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func type_in_question_linedit(number: String):
	var QuestionLineEdit: LineEdit
	if get_viewport_rect().size.y > get_viewport_rect().size.x:
		QuestionLineEdit = get_node("%QuestionLineEdit2")
	else:
		QuestionLineEdit = get_node("%QuestionLineEdit")
	if number == "backspace":
		QuestionLineEdit.text = QuestionLineEdit.text.substr(0, len(QuestionLineEdit.text) - 1)
	else:
		QuestionLineEdit.text += number
			
func parent_line_changed():
	if get_viewport_rect().size.y > get_viewport_rect().size.x:
		get_tree().current_scene.line_edit_changed_function(get_node("%QuestionLineEdit2").text)
	else:
		get_tree().current_scene.line_edit_changed_function(get_node("%QuestionLineEdit").text)
