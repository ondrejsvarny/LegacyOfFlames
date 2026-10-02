extends RigidBody2D

var start_position: Vector2

func _ready():
	start_position = global_position

# Called when the detection area detects a body
func _on_detection_area_body_entered(body) -> void:
	if body is Player:
		$AnimationPlayer.play("shake")
		$ShakeTimer.start()

# Called when the ShakeTimer times out
func _on_shake_timer_timeout() -> void:
	set_deferred("freeze", false)
	$CollisionShape2D.disabled = true
	$Timer.start()

# Called when the Timer times out
func _on_timer_timeout() -> void:
	set_deferred("freeze", true)

func respawn():
	set_deferred("freeze", true)
	global_position = start_position
	$CollisionShape2D.disabled = false
