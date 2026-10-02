extends Node2D

@onready var timer = $dash_timer

func start_dash(dur):
	if Global.can_dash:
		timer.wait_time = dur
		timer.start()
		

func is_dashing():
	if !timer.is_stopped():
		return true
	else:
		return false


func _on_dash_timer_timeout() -> void:
	Global.can_dash = false
