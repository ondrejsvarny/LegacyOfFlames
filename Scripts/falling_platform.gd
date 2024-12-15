extends RigidBody2D

var blinkingCount = 0

@onready var sprite: Sprite2D = $Sprite2D

func _on_detection_area_body_entered(body) -> void:
	if body is Player:
		blink()

func blink():
	if blinkingCount < 5:
		$TimerBlinking.start()
		sprite.visible = false
		blinkingCount += 1
	else:
		queue_free()
		
func _on_timer_blinking_timeout() -> void:
	sprite.visible = true
	$TimerBlinkingVisible.start()
	
	
	
func _on_timer_blinking_visible_timeout() -> void:
	blink()
