extends Control



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
	Global.current_level = 1;

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")
	Global.current_level = 2;
