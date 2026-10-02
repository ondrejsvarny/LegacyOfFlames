extends State

@onready var attack_1: CollisionPolygon2D = $"../../Attack/Attack1"
@onready var attack_2: CollisionPolygon2D = $"../../Attack/Attack2"

var DAMAGE = 20


const HIT_DELAY = 0.3



func enter():
	super.enter()
	if not attack_1 or not attack_2:
		return

	attack_1.disabled = true
	attack_2.disabled = true

	
	combo()


func attack(move = "1"):
	animation_player.play("melee_attack_" + move)
	
	
	await get_tree().create_timer(HIT_DELAY).timeout
	if move == "1":
		activate_attack_1()
	elif move == "2":
		activate_attack_2()
	
	
	await get_tree().create_timer(0.1).timeout
	disable_attack_1()
	disable_attack_2()

	
	await animation_player.animation_finished


func combo():
	var move_set = ["1", "1", "2"]
	for move in move_set:
		await attack(move)
	
	combo()

func transition():
	if owner.direction.length() > 50:
		get_parent().change_state("Follow")


func activate_attack_1():
	if attack_1:
		attack_1.disabled = false

func activate_attack_2():
	if attack_2:
		attack_2.disabled = false

func disable_attack_1():
	if attack_1:
		attack_1.disabled = true

func disable_attack_2():
	if attack_2:
		attack_2.disabled = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished


func _on_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.dashing == true:
			Global.player_health -= DAMAGE
