extends Control



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level2.tscn")
