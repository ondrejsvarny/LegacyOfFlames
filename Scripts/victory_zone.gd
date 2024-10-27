extends Area2D

@onready var victory_menu: Control = %VictoryMenu


func _on_body_entered(body) -> void:
	victory_menu.menu_on()
