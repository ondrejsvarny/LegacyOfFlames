extends AnimatedSprite2D

func _on_ready() -> void:
	play("witch")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Dialogic.start("witch_1")
