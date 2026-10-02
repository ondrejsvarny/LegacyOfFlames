extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var healthbar: ProgressBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Boss_States/Death/Timer
@onready var healthbar: ProgressBar = $"../UI/HealthBar"


var direction: Vector2

var health_changed = 50
var health = 10

var DAMAGE = 40

func _ready() -> void:
	set_physics_process(false)
	healthbar.init_health(health)

func _process(delta: float) -> void:
	if health_changed != health:
		healthbar.health = health
		health_changed = health
	
	
	direction = player.position - position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
	

func death():
	timer.start()
	set_physics_process(false)
	animated_sprite.play("death")
	find_child("Boss_States").change_state("Death")



func _on_timer_timeout() -> void:
		queue_free()



func _on_enemy_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
		else:
			health -= Global.dash_damage
			if health <= 0:
				healthbar.queue_free()
