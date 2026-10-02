extends State

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("armor_buff")
	owner.health += 50
	owner.health = min(owner.health, 200) 
	await animation_player.animation_finished
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Follow")
