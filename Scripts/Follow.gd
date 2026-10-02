extends State

@onready var armor_timer: Timer = %ArmorTimer
var can_heal: bool = true  

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()

	
	
			

	if distance < 55:
		get_parent().change_state("Melee_Attack")
	elif distance >= 110:
		var chance = randi() % 3
		match chance:
			0:
				get_parent().change_state("Homing_missle")
			1:
				get_parent().change_state("Laser_Beam")
			2:
				get_parent().change_state("Ranged_attack")

func heal_and_restart_timer():
	
	can_heal = false  
	owner.health += 50
	armor_timer.start() 
	get_parent().change_state("ArmorBuff") 

func _on_armor_timer_timeout() -> void:
	can_heal = true


func _on_enemy_body_entered(body: Node2D) -> void:
	if can_heal and armor_timer.is_stopped():
		if owner.health < 400:
			heal_and_restart_timer()
