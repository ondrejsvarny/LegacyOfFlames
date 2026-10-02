extends AnimatedSprite2D

@onready var animated_sprite = $"."
@onready var timer = $Timer
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
var hit = false
const DAMAGE = 30 #NEED TO CHANGE IN ANOTHER TOO
const SPEED = 3.5 #NEED TO CHANGE IN ANOTHER TOO

func _physics_process(delta):
	if !hit:
		position.x -= SPEED

func _on_area_2d_body_entered(body):
	hit = true
	animated_sprite.play("hit")
	shape.queue_free()
	timer.start()

func _on_area_2d_area_entered(area):
	if area.name == "Player" and Global.dashing == true:
		Global.player_health -= DAMAGE
	
	hit = true
	animated_sprite.play("hit")
	shape.queue_free()
	timer.start()

func _on_timer_timeout():
	queue_free()
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
