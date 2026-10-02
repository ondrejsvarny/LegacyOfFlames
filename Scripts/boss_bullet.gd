extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_parent().find_child("Player")
@onready var timer = $Timer

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var is_exploding: bool = false

var DAMAGE = 30

func _ready():
	if timer:
		timer.start()
		timer.connect("timeout", Callable(self, "explode"))

func _physics_process(delta: float) -> void:
	if player and not is_exploding:
		acceleration = (player.position - position).normalized() * 700
		
		velocity += acceleration * delta
		velocity = velocity.limit_length(120)
		
		position += velocity * delta
		rotation = velocity.angle()

func explode():
	if is_exploding:
		return
	
	is_exploding = true
	velocity = Vector2.ZERO  
	if animated_sprite:
		animated_sprite.play("kaboom")  
		animated_sprite.connect("animation_finished", Callable(self, "on_explosion_finished"))
		

func on_explosion_finished():
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
			explode()
