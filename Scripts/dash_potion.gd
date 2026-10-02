extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		if Global.picked == null:
			Global.picked = "dash"
		else:
			Global.dash_cooldown = "dash_special"
		set_collision_mask_value(2,0)
		animated_sprite.play("collected")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
