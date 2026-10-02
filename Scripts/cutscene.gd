extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready():
	Global.can_move = false
	# Connect signal if not already connected
	if not animation_player.is_connected("animation_finished", _on_animation_finished):
		animation_player.connect("animation_finished", _on_animation_finished)
	
	animation_player.play("cutscene1")
	if animation_player.is_playing():
		Dialogic.start("intro_level1")
		timer.start()
		
func _on_animation_finished(anim_name):
	print("Cutscene finished!")  # Debug check
	end_cutscene()

func end_cutscene():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Basic/loading_screen.tscn")


func _on_timer_timeout() -> void:
	Dialogic.end_timeline()
