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

const PUSH_FORCE = 50
const MAX_VELOCITY = 100

@onready var dash = $Dash
@onready var cam: Camera2D = %Cam

@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
var rng = RandomNumberGenerator.new()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var bullet = preload("res://Scenes/Shooting/bullet.tscn")
@onready var bullet_left = preload("res://Scenes/Shooting/bullet_left.tscn")

@onready var ladder_raycast: RayCast2D = $LadderRaycast
@onready var top_ladder_cast: RayCast2D = $TopLadderCast
@onready var drop_ladder_cast: RayCast2D = $DropLadderCast

var b # bullet instance
var b_l
var shoot_anm = false # shoot animation is ongoing

var jump_max = 2
var jump_count = 0
var is_facing_right = true 
var jump_buffer_time = 0.1 #cas pocas ktoreho hrac uz moze skocit aj ked este neni na zemi
var jump_buffer_timer = 0.0
var gravity_fall_multiplier = 1.3


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
	alive()

func alive():
	CheckpointManager.player = self
	Global.fall_death = false
	Global.can_move = true
	Global.can_attack = true
	dead = false
	health = Global.max_player_health
	hurt = false
	set_physics_process(true)

func ladder_climb(delta):
	jump_count = 0
	hurt = false
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left","move_right")
	direction.y = Input.get_axis("jump","crouch")
	
	var topCollider = top_ladder_cast.get_collider()
	
	if direction.y < 0 and not topCollider:
		direction.y = 0  # Zablokuj pohyb nahor
	
	velocity = direction * normal_speed / 2
	
	animated_sprite.play("climb")
	if velocity: animated_sprite.play("climb")
	else: animated_sprite.stop()

func movement(delta):
	# Add the GRAVITY
	if not Global.can_move:
		velocity.x = 0
	
	if not is_on_floor():
		if velocity.y <= 0:  
			velocity.y += gravity * delta
		else:  
			velocity.y += gravity * gravity_fall_multiplier * delta
	
	# handle DASH
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
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
		
	# Handle WALLJUMP - wallslide
	
	var collisione = self.get_last_slide_collision()
	if is_instance_valid(collisione):
		var collider = collisione.get_collider()
		if is_instance_valid(collider) and collider.name == "WallJumpLayer":
			#WALL JUMPABLE
			if is_on_wall() and !is_on_floor() and velocity.y > 0:
				hurt = false
				jump_count = 0
				velocity.y = WALL_SLIDE_SPEED
				is_wallsliding = true
			else:
				is_wallsliding = false
	
			if is_wallsliding and Input.is_action_just_pressed("jump"):
				rng.randomize()
				jump_audio.pitch_scale = rng.randf_range(0.8, 1.2)
				jump_audio.play()
				hurt = false
				var wall_direction = -1
				var jump_direction = Input.get_axis("move_left", "move_right")
		
				if jump_direction == 0:
					velocity.y = WALL_UPWRD_BOOST
					velocity.x = 0
			
				else:
					velocity.y = WALL_JUMP_VELOCITY
					velocity.x = wall_direction * normal_speed * -1
		
				#jump_count += 1 
				jump_count == 0 #ROZHODNUT AKO
		
	# Reset jump_count
	if is_on_floor() and jump_count != 0:
		jump_count = 0

	# Handle JUMP
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if (is_on_floor() or jump_count < jump_max) and jump_buffer_timer > 0 and Global.can_move:
		var current_buffer = jump_buffer_timer  # TEST BUFFER 1
		rng.randomize()
		if jump_count == 0:
			jump_audio.pitch_scale = rng.randf_range(0.8, 1.0)
		else:
			jump_audio.pitch_scale = rng.randf_range(1.0, 1.2)
		jump_audio.play()
		
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		jump_buffer_timer = 0  
		
		# TEST BUFFER 2
		if is_on_floor() and current_buffer < jump_buffer_time:
			print("JUMP VDAKA BUFFERU!") 
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
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
	

func health_heal(heal): # Used for local health var when health is healed (via potion)
	if heal == -1:
		health = Global.max_player_health
	else:
		health += heal

func _physics_process(delta):
	
	# LADDER or NORMAL MOVEMENT
	var ladderCollider = ladder_raycast.get_collider()
	var dropCollider = drop_ladder_cast.get_collider()
	if ladderCollider && dropCollider && !is_on_floor(): ladder_climb(delta)
	else: movement(delta)
	print(Global.player_health)	
	print("h"+str(health))
	# HURT	
	if health > Global.player_health and not Global.fall_death:
		print("hurt")
		health = Global.player_health
		velocity.y = -300
		jump_count = 2
		hurt = true
	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		if is_instance_valid(collision_box) and collision_box.is_in_group("boxes") and abs(collision_box.get_linear_velocity().x) < MAX_VELOCITY:
			collision_box.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
			
	move_and_slide()
	
