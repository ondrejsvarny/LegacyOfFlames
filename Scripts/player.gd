extends CharacterBody2D
class_name Player

var normal_speed = 100.0
const JUMP_VELOCITY = -300.0

const dash_speed = 600
const dash_length = .1

const WALL_SLIDE_SPEED = 40.0
const WALL_JUMP_VELOCITY = -170.0 
const WALL_UPWRD_BOOST = - -250.0
var is_wallsliding = false
var is_walljumping = false

@onready var dash = $Dash

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var bullet = preload("res://Scenes/Shooting/bullet.tscn")
@onready var bullet_left = preload("res://Scenes/Shooting/bullet_left.tscn")

var b # bullet instance
var b_l
var shoot_anm = false # shoot animation is ongoing

var jump_max = 2
var jump_count = 0
var is_facing_right = true 


@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D

var health 
var hurt = false
var dead = false

# SHOOTING
func attack():
	Global.can_attack = false
	animated_sprite.play("shoot") 
	if is_facing_right:
		b = bullet.instantiate()
		b.global_position = $BulletSpawn.global_position
		get_parent().add_child(b)
	else:
		b_l = bullet_left.instantiate()
		b_l.global_position = $BulletSpawnLeft.global_position
		get_parent().add_child(b_l)
				
	timer.start()
	shoot_anm = true

func death():
	Global.can_attack = false
	dead = true

func _on_timer_timeout():
	shoot_anm = false
	


func _ready() -> void:
	Global.can_move = true
	Global.can_attack = true
	dead = false
	health = Global.max_player_health

func _physics_process(delta):
	
	# Add the GRAVITY

	if not Global.can_move:
		velocity.x = 0
	

	if not is_on_floor():
		velocity.y += gravity * delta

	# Reset jump_count
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	
	if Input.is_action_just_pressed("dash") and Global.can_move and not shoot_anm:
		dash.start_dash(dash_length)
		animated_sprite.play("run")
	
	var speed = dash_speed if dash.is_dashing() else normal_speed
	
	if dash.is_dashing():
		Global.dashing = false
		velocity.x = speed
		velocity.y = 0
	
	if not dash.is_dashing():
		Global.dashing = true
		
	#Handle Walljump - wallslide
	if is_on_wall() and !is_on_floor() and velocity.y > 0:
		jump_count = 0
		velocity.y = WALL_SLIDE_SPEED
		is_wallsliding = true
	else:
		is_wallsliding = false
	
	if is_wallsliding and Input.is_action_just_pressed("jump"):
		var wall_direction = -1
		var jump_direction = Input.get_axis("move_left", "move_right")
		
		if jump_direction == 0:
			velocity.y = WALL_UPWRD_BOOST
			velocity.x = 0
			
		else:
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = wall_direction * normal_speed * -1
		
		jump_count += 1
		

	#Handle Jump
	if Input.is_action_just_pressed("jump") and jump_count < jump_max and Global.can_move:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	# Handle crouch
	if Input.is_action_pressed("crouch") and is_on_floor():
		$CrouchShape2D.disabled = false
		$CollisionShape2D.disabled = true
	else:
		$CrouchShape2D.disabled = true
		$CollisionShape2D.disabled = false

	# Get input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
		is_facing_right = true
	elif direction < 0:
		animated_sprite.flip_h = true
		is_facing_right = false
		
		
	# Play other animations
	if Global.can_move:
		if not shoot_anm:
			if is_on_floor():
				hurt = false
				if direction == 0 and not Input.is_action_pressed("crouch"):
					animated_sprite.play("idle")
					
				elif Input.is_action_pressed("crouch"):
					animated_sprite.play("crouch")
				
				else:
					animated_sprite.play("run")
				
			else:  #ZMENA
				if jump_count == 1:
					animated_sprite.play("jump")
				else:
					if dead:
						set_physics_process(false)
						animated_sprite.play("death")
					elif hurt:
						animated_sprite.play("hurt") 
					else:
						animated_sprite.play("second_jump")
				
			
		
	if not Global.can_move:
		if is_on_floor():
			
			hurt = false
			if direction == 0 and not Input.is_action_pressed("crouch"):
				animated_sprite.play("idle")
			
			if Input.is_action_pressed("crouch"):
				animated_sprite.play("crouch")
			
			else:
				animated_sprite.play("idle")
	
	# Apply movement

	if direction and not Input.is_action_pressed("crouch") and shoot_anm == false:
		velocity.x = direction * speed

	if direction and not Input.is_action_pressed("crouch") and shoot_anm == false and not shoot_anm and Global.can_move:
		velocity.x = direction * speed
	

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	if health != Global.player_health:
		health = Global.player_health
		velocity.y = -300
		jump_count = 2
		hurt = true
	
	move_and_slide()
	
