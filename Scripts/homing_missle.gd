extends State

@export var boss_bullet: PackedScene = preload("res://Scenes/Enemies/boss_bullet.tscn")
var can_transition: bool = false


func enter():
	super.enter()
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = boss_bullet.instantiate()
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)
	


func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
		
