extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/LevelMenu.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/OptionsMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
