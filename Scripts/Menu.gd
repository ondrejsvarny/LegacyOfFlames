extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/LevelMenu.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_character_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/character_menu.tscn")
