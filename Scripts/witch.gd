extends AnimatedSprite2D 

var token = 0
var current_dialogue_name = ""

func _ready() -> void:
	play("witch")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("zahrievanie")  
	current_dialogue_name = "zahrievanie" 
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and token == 0:
		token += 1
		current_dialogue_name = "witch_1"
		Dialogic.start(current_dialogue_name)  
		_on_dialog_started(current_dialogue_name)  

func _on_dialog_started(dialogue_id: String):
	Global.can_move = false

func _on_dialogic_signal(argument: String) -> void:
	Global.can_move = true
