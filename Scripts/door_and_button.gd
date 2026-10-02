extends Node2D


@onready var button: AnimatedSprite2D = $Button
@onready var door: AnimatedSprite2D = $Door
@onready var door_body: StaticBody2D = %DoorBody
@onready var collision_door: CollisionShape2D = %CollisionShape2D

var opened = false
var objects_in = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("boxes") or body.is_in_group("player"):
		objects_in += 1
		button.play("down")
		door.play("opening")
		opened = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("boxes") or body.is_in_group("player"):
		objects_in -=1
	if objects_in == 0:
		door_body.set_collision_mask_value(2,1)
		door_body.set_collision_layer_value(2,1)
		door.visible = true
		button.play("up")
		door.play_backwards("opening")
		opened = false

func _on_door_animation_finished() -> void:
	if opened:
		door_body.set_collision_mask_value(2,0)
		door_body.set_collision_layer_value(2,0)
		door.visible = false
	else:
		door.play("closed")
		
