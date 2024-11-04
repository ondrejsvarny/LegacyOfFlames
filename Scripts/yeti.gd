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

func _ready():
	healthbar.init_health(health)

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
	
	position.x += direction * SPEED * delta

	
func _on_enemy_body_entered(body):
	Global.player_health -= DAMAGE
