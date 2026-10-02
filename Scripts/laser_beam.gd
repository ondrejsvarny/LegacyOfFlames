extends State

@onready var pivot: Node2D = $"../../Pivot"
@onready var laser_area = pivot.get_node("Laser") # Accessing Area2D
@onready var laser_shape = laser_area.get_node("CollisionShape2D") # Accessing CollisionShape2D
@onready var sprite = laser_area.get_node("Sprite2D") # Accessing Sprite2D for visuals
@onready var collision_delay_timer: Timer = $"../../Pivot/Laser/Timer"


var DAMAGE = 25

func enter():
	super.enter()
	if laser_shape == null:
		return
		
	laser_shape.disabled = true
	sprite.visible = false
	
	await play_animation("laser_cast")
	rotate_laser_to_player()
	collision_delay_timer.start() 
	await play_animation("laser")
	deactivate_laser()
	
	
	get_parent().change_state("Dash") 


func exit():
	super.exit()
	laser_shape.disabled = true

func activate_laser():
	if laser_shape:
		laser_shape.disabled = false
		sprite.visible = true 
		

func deactivate_laser():
	if laser_shape:
		laser_shape.disabled = true 
		sprite.visible = false 
		
	

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func rotate_laser_to_player():
	if owner.player:
		var direction = (owner.player.position - pivot.global_position).normalized()
		pivot.rotation = direction.angle()
	


func _on_timer_timeout() -> void:
	activate_laser()


func _on_laser_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
