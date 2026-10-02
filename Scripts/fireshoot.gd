extends Node2D

const DAMAGE = 20
var health = 50

var previous_x = 0.0
@export var player: CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $HealthBar

@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var ray_cast_up: RayCast2D = $AnimatedSprite2D/RayCast2D2

@onready var bullet = preload("res://Scenes/Shooting/enemy_bullet.tscn")
@onready var bullet_left = preload("res://Scenes/Shooting/enemy_bullet_left.tscn")
@onready var timer: Timer = $ShootTimer

var health_changed = 50  # at the start same as the health
var dead
var colliding = false
var can_shoot = true
var left = false
var b # bullet instance
var b_l

func _ready():
	print("ready")
	healthbar.init_health(health)
	dead = false
	previous_x = position.x 

func _physics_process(delta: float) -> void:
	look_for_player()
	attack()

func _process(delta):
	if health_changed != health:
		healthbar.health = health
		health_changed = health
		
	if position.x < previous_x: 
		animated_sprite.flip_h = true 
		left = true
		ray_cast.target_position = Vector2(-125, 0)
		ray_cast_up.target_position = Vector2(-125, 0)
	elif position.x > previous_x: 
		animated_sprite.flip_h = false
		left = false
		ray_cast.target_position = Vector2(125, 0)
		ray_cast_up.target_position = Vector2(125, 0)
	previous_x = position.x
	
func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			colliding = true
		else:
			colliding = false
	elif ray_cast_up.is_colliding():
		var collider = ray_cast_up.get_collider()
		if collider == player:
			colliding = true
		else:
			colliding = false
	else:
		colliding = false
		

func attack():
	if not left and colliding and can_shoot:
		can_shoot = false
		timer.start()
		b = bullet.instantiate()
		b.global_position = $BulletSpawn.global_position
		get_parent().add_child(b)
	elif colliding and can_shoot:
		can_shoot = false
		timer.start()
		b_l = bullet_left.instantiate()
		b_l.global_position = $BulletSpawnLeft.global_position
		get_parent().add_child(b_l)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
func death():
	dead = true
	ray_cast.set_collision_mask_value(2,0)
	ray_cast_up.set_collision_mask_value(2,0)
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
