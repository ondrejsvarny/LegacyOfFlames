extends Control

@onready var camera: Camera2D = $MenuBackgroud/Camera2D

func _ready() -> void:
	if not Global.menu_first_time:
		camera.position = Vector2(160, -45)
	Global.menu_first_time = false

func _on_play_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/LevelMenu.tscn")

func _on_options_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_character_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/character_menu.tscn")

func _on_button_pressed() -> void:
	$Button.queue_free()
	$Continue.play("intro_to_menu")
