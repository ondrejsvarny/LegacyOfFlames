extends Node2D

@onready var player: Player = %Player
@onready var player_cam: Camera2D = %Player/Cam

func _ready() -> void:
	player.set_script(null)
	player_cam.queue_free()

func _process(delta: float) -> void:
	pass
