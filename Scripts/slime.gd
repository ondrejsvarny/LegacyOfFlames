extends Node2D

@export var force = -450.0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.y = force
		body.jump_count = 1

		$AnimatedSprite2D.play("slime")
	else:
		$AnimatedSprite2D.play("idle")


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.stop() 
	$AnimatedSprite2D.play("idle")
