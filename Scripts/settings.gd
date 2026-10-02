extends Control

@onready var input_button_scene = preload("res://Scenes/UI/Keybinds.tscn")
@onready var screen_mode: OptionButton = %Screen_mode
@onready var v_sync_toggle: CheckBox = %VSync
@onready var key_list: VBoxContainer = %KeyList
@onready var volume_slider: HSlider = %Volume
@onready var mute_toggle: CheckBox = %Mute

var is_remapping = false
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
	load_settings()
	_create_key_list()

# Volume settings
func _on_volume_value_changed(value: float) -> void:
	var db_value = remap(value, volume_slider.min_value, volume_slider.max_value, -30.0, 0.0)
	AudioServer.set_bus_volume_db(0, db_value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

# Screen mode
func _on_screen_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# V-Sync
func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

# Key binding system
func _create_key_list():
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
		if (event is InputEventKey or 
			(event is InputEventMouseButton and event.pressed)):
				
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
				return

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event.duplicate())
			_update_key_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_key_list(button, event):
	button.find_child("Input_label").text = event.as_text().trim_suffix(" (Physical)")

# Save a Load 
func save():
	var key_bindings = {}
	for action in input_actions.keys():
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			key_bindings[action] = _event_to_dict(events[0])
		else:
			key_bindings[action] = null

	var settings_data = {
		"screen_mode": screen_mode.selected,
		"v_sync": v_sync_toggle.button_pressed,
		"volume": volume_slider.value,
		"mute": mute_toggle.button_pressed,
		"key_bindings": key_bindings
	}
	
	SaveManager.save_section("game_settings", settings_data)

func load_settings():
	var data = SaveManager.load_section("game_settings")
	if data.has("screen_mode"):
		screen_mode.selected = data["screen_mode"]
		_on_screen_mode_item_selected(data["screen_mode"])
	if data.has("v_sync"):
		v_sync_toggle.button_pressed = data["v_sync"]
		_on_v_sync_toggled(data["v_sync"])
	if data.has("volume"):
		volume_slider.value = data["volume"]
		_on_volume_value_changed(data["volume"])
	if data.has("mute"):
		mute_toggle.button_pressed = data["mute"]
		_on_mute_toggled(data["mute"])

	if data.has("key_bindings"):
		for action in input_actions.keys():
			if data["key_bindings"].has(action) and data["key_bindings"][action] != null:
				var event = _dict_to_event(data["key_bindings"][action])
				if event:
					InputMap.action_erase_events(action)
					InputMap.action_add_event(action, event)

func _event_to_dict(event: InputEvent) -> Dictionary:
	var dict = {}
	if event is InputEventKey:
		dict["type"] = "key"
		dict["keycode"] = event.keycode
		dict["physical"] = event.physical_keycode
		dict["ctrl"] = event.ctrl_pressed
		dict["shift"] = event.shift_pressed
		dict["alt"] = event.alt_pressed
	elif event is InputEventMouseButton:
		dict["type"] = "mouse"
		dict["button"] = event.button_index
		dict["ctrl"] = event.ctrl_pressed
		dict["shift"] = event.shift_pressed
		dict["alt"] = event.alt_pressed
	return dict

func _dict_to_event(dict: Dictionary) -> InputEvent:
	match dict.get("type"):
		"key":
			var event = InputEventKey.new()
			event.keycode = dict["keycode"]
			event.physical_keycode = dict["physical"]
			event.ctrl_pressed = dict.get("ctrl", false)
			event.shift_pressed = dict.get("shift", false)
			event.alt_pressed = dict.get("alt", false)
			return event
		"mouse":
			var event = InputEventMouseButton.new()
			event.button_index = dict["button"]
			event.ctrl_pressed = dict.get("ctrl", false)
			event.shift_pressed = dict.get("shift", false)
			event.alt_pressed = dict.get("alt", false)
			return event
	return null

# Reset and navigation
func _on_restore_pressed() -> void:
	InputMap.load_from_project_settings()
	_create_key_list()

func _on_apply_pressed() -> void:
	save()

func _on_back_pressed() -> void:
	save()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
