extends Control

@onready var input_button_scene = preload("res://Scenes/UI/Keybinds.tscn")
@onready var key_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList/KeyList
@onready var screen_mode: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList/Screen_mode
@onready var vsync_toggle: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList/VSync

# Volume
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

# Screen mode
func _on_screen_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

#Vsync
func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ProjectSettings.set_setting("display/window/vsync/vsync_mode", 1)
	else:
		ProjectSettings.set_setting("display/window/vsync/vsync_mode",0)
	
	

# Key binding
var is_remapping = false
var action_to_remap = null

var remapping_button = null

var input_actions = {
	"move_left": "Move right",
	"move_right": "Move right",
	"crouch": "Crouch",
	"jump": "Jump",
	"attack": "Attack",
	"dash": "Dash"
}

func _ready() -> void:
	#load_data()
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
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		key_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Input_label").text = "Press key to bind ..."

func _input(event):
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
				return
			
			# Clear previous mappings and apply the new one
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_key_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()


func _update_key_list(button, event):
	button.find_child("Input_label").text = event.as_text().trim_suffix(" (Physical)")

# Restore the key list to its default state
func _on_restore_pressed() -> void:
	_create_key_list()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
	
	

"""
func save():
	var data = {
		"screen_mode": screen_mode,
	}
	SaveManager.save_section("settings", data)

func load_data():
	var data = SaveManager.load_section("settings")
	if data:
		screen_mode = data.get("screen_mode", {})
	

func _on_apply_pressed() -> void:
	save()
"""
