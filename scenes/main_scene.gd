extends Control

var operation = "addition"
var num1: int
var num2: int
var sum: int

var start_of_puzzle_number = 0
var update_number = false
var frozen_answer = ""

@export var addition = true
@export var subtraction = true
@export var multiplication = true
@export var division = true
@export var enabled_options = 4
var startup_count = 3

@export var muted = false

var is_ios_or_android

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	muted = Globals.muted
	$Question/Label.text = ""
	$QuestionStopwatch/Label.text = ""
	if !muted:
		$"Startup Beep".play()
		
	is_ios_or_android = JavaScriptBridge.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)
	if is_ios_or_android:
		if get_viewport_rect().size.x > get_viewport_rect().size.y:
			$Numpads.visible = true
		else:
			$Numpads2.visible = true
			$"Math Buttons".scale = Vector2(2, 2)
			$AudioButton.scale = Vector2(3, 3)
			$Question.scale = Vector2(1.5, 1.5)
			$Question.position.y = 332
			$"Question Marker2".scale = Vector2(3, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Question.position.x = get_viewport_rect().size.x / 2
	$"Question Marker2".position.x = get_viewport_rect().size.x / 2
	$QuestionStopwatch.position.x = get_viewport_rect().size.x / 2
	$"Math Buttons".position.x = get_viewport_rect().size.x * 0.083333333
	$"Math Buttons".position.y = get_viewport_rect().size.y / 2
	if !is_ios_or_android:
		$AudioButton.position.x = get_viewport_rect().size.x * 0.953993056
	else:
		$AudioButton.position.x = get_viewport_rect().size.x * 0.893229167
	$OpenSourceDisclaimer.position.x = get_viewport_rect().size.x * 0.842013889
	$Numpads.position.x = get_viewport_rect().size.x * 0.895833333
	$Numpads2.position.x = get_viewport_rect().size.x / 2
	
	if update_number:
		$QuestionStopwatch/Label.text = str("%.2f" % ((Time.get_ticks_msec() - start_of_puzzle_number) / 1000.0))
	elif $Question/QuestionLineEdit.text != frozen_answer:
		$Question/QuestionLineEdit.text = frozen_answer
		$Question/QuestionLineEdit.add_theme_color_override("font_color", Color.from_string("06963aff", Color(1, 1, 1)))
		

func line_edit_changed_function(new_text: String):
	if update_number and !muted:
		$Question/TypingAudioStreamPlayer.play()
	
	if new_text == str(sum):
		$Question/QuestionLineEdit.add_theme_color_override("font_color", Color.from_string("06963aff", Color(1, 1, 1)))
		update_number = false
		frozen_answer = new_text
		$"Correct Answer Delay".start()
		$Tick/AudioStreamPlayer.stop()
		if !muted:
			$CorrectAnswerChime.play()
	else:
		$Question/QuestionLineEdit.add_theme_color_override("font_color", Color.from_string("f6145eff", Color(1, 1, 1)))

func _on_line_edit_text_changed(new_text: String) -> void:
	line_edit_changed_function(new_text)

func get_operation_from_number(number: int, operation_array=[["addition", addition], ["subtraction", subtraction], ["multiplication", multiplication], ["division", division]]):
	if operation_array[number][1]:
		operation = operation_array[number][0]
	else:
		operation_array.remove_at(number)
		get_operation_from_number(number, operation_array)

func get_random_number_and_perform_operation():
	if operation == "addition":
		num1 = randi_range(1, 100)
		num2 = randi_range(1, 100)
		sum = num1 + num2
	if operation == "subtraction":
		num1 = randi_range(1, 100)
		num2 = randi_range(1, 100)
		sum = num1 - num2
	if operation == "multiplication":
		num1 = randi_range(2, 20)
		num2 = randi_range(2, 20)
		sum = num1 * num2
	if operation == "division":
		num1 = randi_range(1, 100)
		num2 = randi_range(1, 10)
		sum = int(num1 / num2)

func apply_vars_to_ui():
	if operation == "addition":
		$Question/Label.text = str(num1) + " + " + str(num2) + " = "
	if operation == "subtraction":
		$Question/Label.text = str(num1) + " - " + str(num2) + " = "
	if operation == "multiplication":
		$Question/Label.text = str(num1) + " × " + str(num2) + " = "
	if operation == "division":
		$Question/Label.text = str(num1) + " ÷ " + str(num2) + " = "
	$Question/QuestionLineEdit.text = ""
	if !is_ios_or_android:
		$Question/QuestionLineEdit.grab_focus()


func _on_correct_answer_delay_timeout() -> void:
	update_number = true
	if !muted:
		$Tick/AudioStreamPlayer.play()
	the_holy_trinity()

func the_holy_trinity():
	get_operation_from_number(randi_range(0, enabled_options-1))
	get_random_number_and_perform_operation()
	apply_vars_to_ui()
	
	# This step makes the function not a trinity, but when this
	# this function was named it was only the three functions above.
	# And I really liked the name so I'm keeping it this way.
	start_of_puzzle_number = Time.get_ticks_msec()

func conditional_holy_trinity(condition: String):
	if condition == operation:
		the_holy_trinity()


func _on_startup_timer_timeout() -> void:
	startup_count -= 1
	$Question/TimerLabel.text = str(startup_count)
	if !muted:
		$"Startup Beep".play()
	if startup_count < 0:
		$Question/TimerLabel.visible = false
		$StartupTimer.stop()
		update_number = true
		the_holy_trinity()
		if !muted:
			$Tick/AudioStreamPlayer.play()


func _on_button_pressed() -> void:
	muted = !muted
	if muted:
		$AudioButton/CenterContainer/enabled.visible = false
		$AudioButton/CenterContainer/disabled.visible = true
		$Tick/AudioStreamPlayer.stop()
	if !muted:
		$AudioButton/CenterContainer/enabled.visible = true
		$AudioButton/CenterContainer/disabled.visible = false
		$"Math Buttons/Addition Button/AudioStreamPlayer".play()
		$Tick/AudioStreamPlayer.play()
