extends Node2D
class_name Game

@export var ui: UI

func _ready():
	# Find the Player node dynamically
	var player = get_node("level1/Player") 

#	if player and !player.collected.is_connected(ui._on_collected):
		#player.collected.connect(ui._on_collected)
