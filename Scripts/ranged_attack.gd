extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

var target_position: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var DAMAGE = 25

func _ready() -> void:
	timer.start()
	if get_parent().find_child("Player"):
		target_position = get_parent().find_child("Player").position

func _physics_process(delta: float) -> void:
	var direction = (target_position - position).normalized() 
	velocity = direction * 250 
	position += velocity * delta
	rotation = velocity.angle()
	
	if position.distance_to(target_position) < 10:
		queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing:
			Global.player_health -= DAMAGE
	queue_free()
	velocity = Vector2.ZERO 


func _on_timer_timeout() -> void:
	queue_free()
