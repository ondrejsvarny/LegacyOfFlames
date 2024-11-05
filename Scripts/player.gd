extends CharacterBody2D
class_name Player

var normal_speed = 125.0
const JUMP_VELOCITY = -300.0
const dash_speed = 600
const dash_length = .1
var original_collision_mask: int

const WALL_SLIDE_SPEED = 40.0
const WALL_JUMP_VELOCITY = -400.0
var is_wallsliding = false
var is_walljumping = false

@onready var dash = $Dash

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var bullet = preload("res://Scenes/Shooting/bullet.tscn")
@onready var bullet_left = preload("res://Scenes/Shooting/bullet_left.tscn")

var b # bullet instance
var b_l
var anm = false # shoot animation is ongoing

var jump_max = 2
var jump_count = 0
var is_facing_right = true 

@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D

var health 
var hurt = false

func _on_timer_timeout():
	anm = false

func _ready() -> void:
	health = Global.max_player_health
	original_collision_mask = collision_mask

func _physics_process(delta):
	
	# Add the gravity only if the player is not dashing
	if not dash.is_dashing() and not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Set vertical velocity to zero when starting the dash
		if dash.is_dashing():
			velocity.y = 0

	# Reset jump_count
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	
	if Input.is_action_just_pressed("dash") and Global.can_move and not anm:
		dash.start_dash(dash_length)
		animated_sprite.play("run")
	
	var speed = dash_speed if dash.is_dashing() else normal_speed
	
	if dash.is_dashing():
		Global.dashing = false
		velocity.x = speed
	
	if not dash.is_dashing():
		Global.dashing = true
		
	# Handle Walljump - wallslide
	if is_on_wall() and !is_on_floor():
		jump_count = 0
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			is_wallsliding = true
			velocity.y = WALL_SLIDE_SPEED
		else:
			is_wallsliding = false
	else:
		is_wallsliding = false
	
	if is_wallsliding and Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			velocity.y = WALL_JUMP_VELOCITY
			jump_count = 0

	# Handle Jump
	if Input.is_action_just_pressed("jump") and jump_count < jump_max and Global.can_move:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Handle crouch
	if Input.is_action_pressed("crouch"):
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
		
	# SHOOTING
	if Input.is_action_just_pressed("attack") and Global.can_attack and Global.can_move:
		Global.can_attack = false
		animated_sprite.play("shoot") 
		if is_facing_right:
			b = bullet.instantiate()
			b.global_position = $BulletSpawn.global_position + Vector2(-35, 0)
			get_parent().add_child(b)	
		else:
			b_l = bullet_left.instantiate()
			b_l.global_position = $BulletSpawnLeft.global_position + Vector2(-35, 0)
			get_parent().add_child(b_l)
				
		timer.start()
		anm = true
		
	# Play other animations
	if Global.can_move:
		if not anm:
			if is_on_floor():
				hurt = false
				if direction == 0 and not Input.is_action_pressed("crouch"):
					animated_sprite.play("idle")
				elif Input.is_action_pressed("crouch"):
					animated_sprite.play("crouch")
				else:
					animated_sprite.play("run")
			else:
				if jump_count == 1:
					animated_sprite.play("jump")
				else:
					if hurt == true:
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
	if direction and not Input.is_action_pressed("crouch") and anm == false:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if health != Global.player_health:
		health = Global.player_health
		velocity.y = -300
		jump_count = 2
		hurt = true
	
	move_and_slide()
