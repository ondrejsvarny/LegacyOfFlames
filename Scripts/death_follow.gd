extends State

func _enter_tree() -> void:
	randomize()

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if owner.direction.length() < 50:
		get_parent().change_state("Melee_Attack")
	if owner.direction.length() > 150:
		var chance = randi() % 2
		match chance:
			1:
				get_parent().change_state("Minion_Spawn")
			2:
				get_parent().change_state("Teleport")
