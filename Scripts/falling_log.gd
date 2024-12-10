extends RigidBody2D



func _on_detection_area_body_entered(body) -> void:
	if body is Player:
		set_deferred("freeze", false)
		$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()
