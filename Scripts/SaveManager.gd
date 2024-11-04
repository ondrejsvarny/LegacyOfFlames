extends Node

#  C:\Users\Ondrej1\AppData\Roaming\Godot\app_userdata\MyGame

var save_path = "user://savegame.save"

# Load the entire save file, or return an empty dictionary if no file exists
func load_data() -> Dictionary:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var data = file.get_var()  # Load the full save data
			file.close()
			return data
	return {}  # Return empty if no save file found

# Save the full data dictionary to file
func save_data(data: Dictionary) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()

# Save a specific section of the save data
func save_section(section_name: String, section_data: Dictionary) -> void:
	var data = load_data()  # Load current save data
	data[section_name] = section_data  # Update only the specified section
	save_data(data)  # Write updated data back to file

# Load a specific section of the save data, returning an empty dictionary if not found
func load_section(section_name: String) -> Dictionary:
	var data = load_data()  # Load current save data
	return data.get(section_name, {})  # Return specified section or empty dict if not found
