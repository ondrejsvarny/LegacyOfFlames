extends CanvasLayer
class_name UI

@onready var score_label1 = 1

#var score = 0:
	#set(new_score):
		#score = new_score
		#_update_score_label()
		
#func _ready():
	#_update_score_label()

#func _update_score_label():
	#score_label.text = str(score)
	
#func _on_collected(collectable) -> void:
	#if collectable:
		#score += 1
		
		

@onready var score_label = $Score

#func _ready():
#	_update_score_label()
	#set_process(true)  # Enable _process callback

#func _process(delta):
	#_update_score_label()

#func _update_score_label():
	#score_label.text = str(Global.cherries)

# Assuming this method is called when a collectable is collected
#func _on_collected(collectable) -> void:
	#if collectable:
		#Global.cherries += 1



