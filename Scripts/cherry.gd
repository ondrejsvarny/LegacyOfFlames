extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _on_body_entered(body):
	Global.cherries += 1
	print("cherries collected: ", Global.cherries)
	set_collision_mask_value(2,0)
	body.collect(self)
	animated_sprite.play("collected")
	timer.start()


func _on_timer_timeout():
	queue_free()
