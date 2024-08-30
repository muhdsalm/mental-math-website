extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	get_parent().type_in_question_linedit("-")
	scale = Vector2(0.74, 0.74)
	get_tree().current_scene.line_edit_changed_function(get_node("%QuestionLineEdit").text)


func _on_button_button_up() -> void:
	scale = Vector2(0.64, 0.64)
