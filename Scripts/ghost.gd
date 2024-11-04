extends CharacterBody2D

@export var player: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300
const DAMAGE = 20
var health = 50
var health_changed = 50 # same as the health

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var ray_cast_up: RayCast2D = $AnimatedSprite2D/RayCast2D2
@onready var timer: Timer = %Timer
@onready var healthbar: ProgressBar = $HealthBar
#@onready var player = playerBasic.get_node("Player") as 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States{
	WANDER,
	CHASE
}
var current_state = States.WANDER

func _ready():
	left_bounds = self.position + Vector2(-125,0)
	right_bounds = self.position + Vector2(125,0)
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()
	
	if health_changed != health:
		healthbar.health = health
		health_changed = health
		if current_state != States.CHASE:  # start chase if health is reduced
			chase_player()
			print("chase")
			
func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif ray_cast_up.is_colliding():
		var collider = ray_cast_up.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta:float):
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
		
	move_and_slide()
		
func change_direction():
	if current_state == States.WANDER:
		if not sprite.flip_h:
			# moving right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				# flip to moving left
				sprite.flip_h = true
				ray_cast.target_position = Vector2(-125, 0)
				ray_cast_up.target_position = Vector2(-125, 0)
		else:
			# moving left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				# flip to moving right
				sprite.flip_h = false
				ray_cast.target_position = Vector2(125, 0)
				ray_cast_up.target_position = Vector2(125, 0)
	else:
		# Chase state, follow player
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			# flip to moving right
			sprite.flip_h = false
			ray_cast.target_position = Vector2(125, 0)
			ray_cast_up.target_position = Vector2(125, 0)
		else:
			# flip to moving left
			sprite.flip_h = true
			ray_cast.target_position = Vector2(-125, 0)
			ray_cast_up.target_position = Vector2(-125, 0)


func handle_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_timer_timeout() -> void:
	current_state = States.WANDER


func _on_enemy_body_entered(body):
	Global.player_health -= DAMAGE
