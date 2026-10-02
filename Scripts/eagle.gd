extends Node2D

const DAMAGE = 20
var health = 50

var previous_x = 0.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $HealthBar

var health_changed = 50  # at the start same as the health
var dead

func _ready():
	healthbar.init_health(health)
	dead = false
	previous_x = position.x 

func _process(delta):
	if health_changed != health:
		healthbar.health = health
		health_changed = health
		
	if position.x < previous_x:
		animated_sprite.flip_h = false 
	elif position.x > previous_x:
		animated_sprite.flip_h = true
	previous_x = position.x
	

func death():
	dead = true
	$Enemy.queue_free()
	$AnimatedSprite2D.play("death")
	$DeathTimer.start()

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_enemy_body_entered(body):
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
		else:
			health -= Global.dash_damage
			if health <= 0:
				death()
