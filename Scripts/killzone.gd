extends Area2D

#@onready var timer = $Timer

var current_checkpoint : checkpoint

func _on_body_entered(body):
	if body is Player:
		Global.fall_death = true #KVOLI ANIMACII V UI
		Global.player_health = 0
	
