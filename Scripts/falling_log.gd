extends RigidBody2D

# Called when the detection area detects a body
func _on_detection_area_body_entered(body) -> void:
	if body is Player:
		$AnimationPlayer.play("shake")
		$ShakeTimer.start()

# Called when the ShakeTimer times out
func _on_shake_timer_timeout() -> void:
	set_deferred("freeze", false)
	$Timer.start()

# Called when the Timer times out
func _on_timer_timeout() -> void:
	queue_free()
