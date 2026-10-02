extends Node2D

@onready var button: AnimatedSprite2D = $Button
@onready var door: AnimatedSprite2D = $Door
@onready var door_body: StaticBody2D = %DoorBody
@onready var collision_door: CollisionShape2D = %CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("boxes") or body.is_in_group("player"):
		button.play("down")
		door.play("opening")

func _on_door_animation_finished() -> void:
	door_body.set_collision_mask_value(2,0)
	door_body.set_collision_layer_value(2,0)
	door.visible = false
		
