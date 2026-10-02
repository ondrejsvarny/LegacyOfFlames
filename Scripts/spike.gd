extends Node2D

@export var DAMAGE: int = 50

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Global.player_health -= DAMAGE
