extends Control

var opacity = 1
var increase = false

@export var should_continue = true
@export var muted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_model_name() != "GenericDevice":
		should_continue = false
		$CotinueText/Label.text = "Unsupported device. This website only runs on desktops. "
		$MobileAppText.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TitleText.position.x = get_viewport_rect().size.x / 2
	$CotinueText.position.x = get_viewport_rect().size.x / 2
	$AudioButton.position.x = get_viewport_rect().size.x * 0.953993056
	$OpenSourceDisclaimer.position.x = get_viewport_rect().size.x * 0.842013889
	if !should_continue:
		$MobileAppText.position.x = get_viewport_rect().size.x / 2
	if !increase and should_continue:
		opacity -= 0.01
		if opacity <= 0:
			increase = true
	elif should_continue:
		opacity += 0.01
		if opacity >= 1:
			increase = false
	print(opacity)
	$CotinueText/Label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, opacity))
	
	if Input.is_action_just_pressed("any_number_key") and should_continue:
		Globals.muted = muted
		get_tree().change_scene_to_file("res://scenes/main_scene.tscn")


func _on_button_pressed() -> void:
	muted = !muted
	if muted:
		$AudioButton/CenterContainer/enabled.visible = false
		$AudioButton/CenterContainer/disabled.visible = true
	if !muted:
		$AudioButton/CenterContainer/enabled.visible = true
		$AudioButton/CenterContainer/disabled.visible = false
		$pop.play()
