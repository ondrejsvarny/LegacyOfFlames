extends Control

@onready var input_button_scene = preload("res://Scenes/UI/Keybinds.tscn")
@onready var key_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList/KeyList


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

#Volume
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)



#Screen mode
func _on_screen_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


#input 
var is_remaping = false
var action_to_remap = null
var remapping_button = null


var input_actions = {
	"move_left": "Move left",
	"move_right": "Move right",
	"crouch": "Crouch",
	"jump": "Jump",
	"attack": "Attack",
	"dash": "Dash"
}


func _ready() -> void:
	_create_key_list()
	
	
func _create_key_list():
	InputMap.load_from_project_settings()
	for item in key_list.get_children():
		item.queue_free()
		
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("Action_Label")
		var input_label = button.find_child("Input_label")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		
		if events.size() > 0:
			input_label.text = events[0].as_text()
		
		else:
			input_label.text = ""
			
		key_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
		
func _on_input_button_pressed(button, action):
	if !is_remaping:
		is_remaping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Input_label").text = "Press key to bind ..." 
		
		
