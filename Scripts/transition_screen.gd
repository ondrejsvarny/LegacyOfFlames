extends CanvasLayer

signal on_transition_finished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition():
	color_rect.color = Color("000000")
	color_rect.visible = true
	animation_player.play("fade_to_black")

func transition_red():
	color_rect.color = Color("ba1700")
	color_rect.visible = true
	animation_player.play("fade_to_red")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")	
	elif anim_name == "fade_to_red":
		on_transition_finished.emit()
		animation_player.play("red_to_normal")
	elif anim_name == "fade_to_normal" or anim_name == "red_to_normal":
		color_rect.visible= false
		
