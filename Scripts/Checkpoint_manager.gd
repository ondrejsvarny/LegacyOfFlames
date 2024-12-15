extends Node

var last_location
var player

func _ready() -> void:
	player = Player
	last_location = player.global_position
