extends Node


var current_checkpoint : checkpoint

var player : Player

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		get_tree().call_group("checkpoint_respawn", "respawn")
