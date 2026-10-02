extends Area2D

@onready var player = get_parent().find_child("Player")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var is_dying = false

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

var can_transition: bool = false


var health = 10
var DAMAGE = 15

func _ready() -> void:
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
	
	if timer:
		timer.start()
		timer.connect("timeout", Callable(self, "death"))

func _physics_process(delta: float) -> void:
	if player:
		acceleration = (player.position - position).normalized() * 700
		
		velocity += acceleration * delta
		velocity = velocity.limit_length(120)
		
		position += velocity * delta

func death():
	set_physics_process(false)
	if is_dying:
		return
	is_dying = true
	animation.play("death")
	await animation.animation_finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
			death()
