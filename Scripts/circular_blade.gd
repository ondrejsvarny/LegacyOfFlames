extends Sprite2D

@export var damage = 30

func _process(delta: float) -> void:
	rotation_degrees += 500 * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Global.player_health -= damage
