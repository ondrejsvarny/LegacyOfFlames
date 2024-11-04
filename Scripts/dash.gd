extends Node2D

@onready var timer = $dash_timer
@onready var cooldown = $dash_cooldown

var can_dash = true

func start_dash(dur):
	if can_dash == true:
		timer.wait_time = dur
		timer.start()
		

func is_dashing():
	if !timer.is_stopped():
		return true
	else:
		return false


func _on_dash_timer_timeout() -> void:
	can_dash = false
	cooldown.wait_time = 3
	cooldown.start()


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
