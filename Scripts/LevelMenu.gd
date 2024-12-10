extends Control

@onready var button_1: Button = $GridContainer/Button
@onready var button_2: Button = $GridContainer/Button2
@onready var button_3: Button = $GridContainer/Button3
@onready var button_4: Button = $GridContainer/Button4
@onready var button_5: Button = $GridContainer/Button5
@onready var button_6: Button = $GridContainer/Button6
@onready var button_7: Button = $GridContainer/Button7
@onready var button_8: Button = $GridContainer/Button8
@onready var button_9: Button = $GridContainer/Button9
@onready var button_10: Button = $GridContainer/Button10


func _ready() -> void:
	load_data()
	setup_buttons()
	
func setup_buttons() -> void:
	var buttons = [ null,
		button_1, button_2, button_3, button_4, button_5,
		button_6, button_7, button_8, button_9, button_10
	]
	
	for i in range(1, 11):
		var button = buttons[i]
		if Global.levels[i]:  # Level je odomknutý
			button.disabled = false
		else:
			button.disabled = true

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")
	Global.current_level = 1;

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_2.tscn")
	Global.current_level = 2;


func load_data():
	var data = SaveManager.load_section("levels")
	if data:
		Global.levels = data.get("levels", [])
