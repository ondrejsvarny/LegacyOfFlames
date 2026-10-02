extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		if Global.picked == null:
			Global.picked = "attack"
		else:
			Global.fireball_reload = "fireball_special"
		set_collision_mask_value(2,0)
		animated_sprite.play("collected")
		timer.start()

func _on_timer_timeout():
	queue_free()
