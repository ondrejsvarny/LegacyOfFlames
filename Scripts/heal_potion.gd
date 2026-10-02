extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		if Global.picked == null:
			Global.picked = "heal"
		else:
			if Global.max_player_health > Global.player_health:
				if (Global.max_player_health - Global.player_health) < 50:
					Global.player_health = Global.max_player_health
					get_tree().call_group("player", "health_heal", -1)
				else:
					Global.player_health += 50
					get_tree().call_group("player", "health_heal", 50)
					
		set_collision_mask_value(2,0)
		animated_sprite.play("collected")
		timer.start()

func _on_timer_timeout():
	queue_free()
