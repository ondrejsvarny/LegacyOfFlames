extends AnimatedSprite2D

@onready var animated_sprite = $"."
@onready var timer = $Timer
var hit = false

func _physics_process(delta):
	if !hit:
		position.x -= Global.fireball_speed

func _on_area_2d_body_entered(body):
	hit = true
	animated_sprite.play("hit")
	timer.start()

func _on_timer_timeout():
	queue_free()
	
func _on_area_2d_area_entered(area):
	if area.name == "Enemy":
		#area.get_parent().animated_sprite.play("death")
		#await get_tree().create_timer(0.5).timeout
		
		area.get_parent().health -= Global.fireball_damage
		
		if area.get_parent().health <= 0:
			area.get_parent().queue_free()
		
		hit = true
		animated_sprite.play("hit")
		timer.start()
		
#func _on_visible_on_screen_notifier_2d_screen_exited():
	


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
