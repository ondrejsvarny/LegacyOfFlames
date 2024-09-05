extends Node

# List of level paths
var levels = [
	"res://Levels/level1.tscn",
	"res://Levels/level2.tscn",
	"res://Levels/level3.tscn"
]

# Current level index
var current_level = 0

# Current level instance
var current_level_instance = null

# Load the initial level
func _ready():
	load_level(current_level)

# Function to load a level by index
func load_level(level_index):
	if current_level_instance:
		current_level_instance.queue_free()
	
	if level_index >= 0 and level_index < levels.size():
		var level_path = levels[level_index]
		var level_scene = load(level_path)
		# current_level_instance = level_scene.instance()
		add_child(current_level_instance)
		current_level = level_index

# Function to load the next level
func load_next_level():
	load_level(current_level + 1)

# Function to reload the current level
func reload_current_level():
	load_level(current_level)

