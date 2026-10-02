extends Node2D

const SPEED = 40
const DAMAGE = 20
var health = 50


@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $HealthBar

var direction = 1
var health_changed = 50  # at the start same as the health
var dead

func _ready():
	healthbar.init_health(health)
	dead = false

func _process(delta):
	if health_changed != health:
		healthbar.health = health
		health_changed = health
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	if !dead:
		position.x += direction * SPEED * delta
	

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
