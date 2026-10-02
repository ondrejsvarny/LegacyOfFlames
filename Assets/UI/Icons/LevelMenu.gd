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

func load_level():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Basic/loading_screen.tscn")  #funguje iba s levelom vo formate "level_X.tscn"

func _on_button_pressed():
	Global.current_level = 1
	start_cutscene()
	

func _on_button_2_pressed():
	Global.current_level = 2
	load_level()

func _on_button_3_pressed():
	Global.current_level = 3
	load_level()
	
func _on_button_4_pressed():
	Global.current_level = 4
	load_level()
	
	
func _on_button_5_pressed():
	Global.current_level = 5
	load_level()

func _on_button_6_pressed():
	Global.current_level = 6
	load_level()


func _on_button_7_pressed():
	Global.current_level = 7
	load_level()

func _on_button_8_pressed():
	Global.current_level = 8
	load_level()

func _on_button_9_pressed():
	Global.current_level = 9
	load_level()

func _on_button_10_pressed() -> void:
	Global.current_level = 10
	load_level()
	#get_tree().change_scene_to_file("res://Scenes/Levels/test_level.tscn")

func _on_back_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func load_data():
	var data = SaveManager.load_section("levels")
	if data:
		Global.levels = data.get("levels", [])
		

func start_cutscene():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/cutscene.tscn")
