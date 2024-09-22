extends AnimatedSprite2D

var token = 0

func _on_ready() -> void:
	Dialogic.start("zahrievanie")
	play("witch")
	Dialogic.connect("dialogic_started", Callable(self, "_on_dialog_started"))
	Dialogic.connect("dialogic_ended", Callable(self, "_on_dialog_ended"))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and token == 0:
		token = token + 1
		Dialogic.start("witch_1")
		

func _on_dialog_started(dialogue_id):
	Global.can_move = false
	
func _on_dialog_ended(dialogue_id):
	Global.can_move = true
