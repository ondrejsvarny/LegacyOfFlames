extends Node2D

@export var object_scene: PackedScene = null
@export_enum("basic", "black", "gold", "white", "basic_snow", "black_snow", "gold_snow", "white_snow") var look: String = "basic"
@onready var chest: AnimatedSprite2D = $Chest

var current_dialogue_name = ""
var token = 0
var not_pay = 0

var chest_id 
var is_opened = false

func _ready() -> void:
	chest_id = str(global_position.x) + str(global_position.y)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("zahrievanie")  
	current_dialogue_name = "zahrievanie"
	if is_opened:
		chest.autoplay = ""
		chest.animation = look + "_open"
		chest.frame = 4
	else: 
		chest.play(look + "_idle")

# When the player enters the area for the first time, start the payment dialogue
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and token == 0 or not_pay >= 1:
		token += 1
		current_dialogue_name = "payment_for_chest"
		Dialogic.start(current_dialogue_name)  
		_on_dialog_started(current_dialogue_name)

# Called whenever a new Dialogic dialogue starts
func _on_dialog_started(dialogue_id: String):
	Global.can_move = false 

func _on_dialogic_signal(argument: String) -> void:
	match argument:
		"PAY":
			if Global.silver_coins >= 50:
				Global.silver_coins -= 50
				chest.play(look + "_open")
				is_opened = true
			else:
				is_opened = false
				not_pay += 1
				Dialogic.start("not_enough_money")
				
		"DON'T PAY":
			is_opened = false
			not_pay += 1
			
		_: 
			pass
	Global.can_move = true
