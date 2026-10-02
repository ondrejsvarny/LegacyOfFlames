extends Node2D

class_name checkpoint

@export var spawnpoint = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var activated = false

func activate():
	CheckpointManager.current_checkpoint = self
	activated = true
	animated_sprite.play("lift")
	$Timer.start()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !activated:
		activate()
		
		
func _on_timer_timeout() -> void:
	animated_sprite.play("up")
