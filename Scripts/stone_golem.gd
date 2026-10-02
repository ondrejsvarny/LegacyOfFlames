extends CharacterBody2D


@onready var player = get_parent().get_node("Player")
@onready var sprite = $Sprite2D
@onready var animationplayer = $AnimationPlayer
@onready var death_timer: Timer = %DeathTimer
@onready var armor_timer: Timer = %ArmorTimer
@onready var healthbar: ProgressBar = $"../UI/HealthBar"

const SPEED = 60.0

var health = 200
var health_changed = 200

var DAMAGE = 25

var direction : Vector2

func _ready() -> void:
	set_physics_process(false)
	healthbar.init_health(health)

func _process(delta: float) -> void:
	if health_changed != health:
		healthbar.health = health
		health_changed = health
		
	
	direction = player.position - position
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func _physics_process(delta: float) -> void:
	if player:
		velocity = direction.normalized() * SPEED
		move_and_collide(velocity * delta)
		
		

func _on_enemy_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
		else:
			health -= Global.dash_damage
			if health <= 0:
				healthbar.queue_free()
		

func death():
	death_timer.start()
	healthbar.queue_free()
	set_physics_process(false)
	animationplayer.play("death")
	find_child("Boss_States").change_state("Death")


func _on_death_timer_timeout() -> void:
	queue_free()
