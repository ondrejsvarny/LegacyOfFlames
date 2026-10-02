extends AnimatedSprite2D

# Variables
var token = 0
var current_dialogue_name = ""

# Potion scenes dictionary
var potion_scenes = {
	"health": preload("res://Scenes/Objects/heal_potion.tscn"),
	"dash": preload("res://Scenes/Objects/dash_potion.tscn"),
	"attack": preload("res://Scenes/Objects/attack_potion.tscn")
}

func _ready() -> void:
	if Dialogic.signal_event:
		Dialogic.signal_event.connect(_on_dialogic_signal)
	
	Dialogic.start("zahrievanie")
	current_dialogue_name = "zahrievanie"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and token == 0:
		token += 1
		current_dialogue_name = "payment_for_chest"
		Dialogic.start(current_dialogue_name)
		_on_dialog_started(current_dialogue_name)


func _on_dialog_started(dialogue_id: String) -> void:
	Global.can_move = false


func _on_dialogic_signal(argument: String) -> void:
	match argument:
		"BUY_HEALTH":
			if Global.silver_coins >= 50:
				Global.silver_coins -= 50
				throw_potion("health")
			else:
				Dialogic.start("not_enough_money")
				
		"BUY_DASH":
			if Global.silver_coins >= 50:
				Global.silver_coins -= 50
				throw_potion("dash")
			else:
				Dialogic.start("not_enough_money")
				
		"BUY_ATTACK":
			if Global.silver_coins >= 50:
				Global.silver_coins -= 50
				throw_potion("attack")
			else:
				Dialogic.start("not_enough_money")

		"PAY":
			if Global.silver_coins >= 50:
				Global.silver_coins -= 50
				Global.player_health += 100
			else:
				Dialogic.start("not_enough_money")
				
		"DON'T_PAY":
			print("Player refused to pay.")
			
		"signal":
			Global.can_move = true


func throw_potion(potion_type: String) -> void:
	if not potion_scenes.has(potion_type):
		push_error("Invalid potion type: " + potion_type)
		return
	
	var throw_direction = Vector2.RIGHT if not flip_h else Vector2.LEFT
	var potion_instance = potion_scenes[potion_type].instantiate()
	var spawn_offset = Vector2(16, -8)  
	var spawn_position = global_position + (throw_direction * spawn_offset.x * Vector2(1, 0)) + Vector2(0, spawn_offset.y)
	potion_instance.global_position = spawn_position
	
	
	get_tree().root.add_child(potion_instance)
	
	
	if potion_instance is RigidBody2D:
		
		var base_impulse = Vector2(200, -100)
		var throw_impulse = Vector2(base_impulse.x * throw_direction.x, base_impulse.y)
		var random_spread = Vector2(randf_range(-20, 20), randf_range(-10, 10))
		
		throw_impulse += random_spread
		potion_instance.apply_central_impulse(throw_impulse)
		potion_instance.apply_torque_impulse(randf_range(-30, 30))
