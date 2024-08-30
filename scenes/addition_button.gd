extends Node2D

@export var on = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	scale = Vector2(0.74, 0.74)


func _on_button_mouse_exited() -> void:
	scale = Vector2(0.64, 0.64)


func _on_button_button_down() -> void:
	if !get_tree().current_scene.muted:
		$AudioStreamPlayer.play()
	scale = Vector2(0.64, 0.64)
	if on and (get_tree().current_scene.enabled_options > 1):
		on = false
		$CenterContainer2/unactivated.visible = true
		$CenterContainer2/activated.visible = false
		get_tree().current_scene.addition = false
		get_tree().current_scene.enabled_options -= 1
		get_tree().current_scene.the_holy_trinity()
	elif !on:
		on = true
		$CenterContainer2/unactivated.visible = false
		$CenterContainer2/activated.visible = true
		get_tree().current_scene.addition = true
		get_tree().current_scene.enabled_options += 1
		get_tree().current_scene.the_holy_trinity()


func _on_button_button_up() -> void:
	scale = Vector2(0.74, 0.74)
