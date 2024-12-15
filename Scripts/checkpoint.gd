extends Area2D

var checkpoint_manager

func _ready() -> void:
		checkpoint_manager = get_node("checkpointmanager")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		checkpoint_manager.last_location = $Respawn_point.global_position
		
