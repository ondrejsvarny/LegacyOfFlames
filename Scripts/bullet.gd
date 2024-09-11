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

func _on_area_2d_area_entered(area):
	if area.name == "Enemy":
		#position.x += 10
		area.get_parent().queue_free()
		hit = true
		animated_sprite.play("hit")
		timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("del")
	queue_free()
	
