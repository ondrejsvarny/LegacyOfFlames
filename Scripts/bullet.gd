extends AnimatedSprite2D

@onready var animated_sprite = $"."
@onready var timer = $Timer
var hit = false
	
func _physics_process(delta):
	if !hit:
		position.x += 3

func _on_area_2d_body_entered(body):
	hit = true
	animated_sprite.play("hit")
	timer.start()

func _on_timer_timeout():
	queue_free()
