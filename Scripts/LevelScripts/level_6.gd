extends Node2D

var boss = preload("res://Scenes/Enemies/death_boss.tscn")
var boss_instance
@onready var door1: AnimatedSprite2D = %Door
@onready var door2: AnimatedSprite2D = %Door2
@onready var door1_body: StaticBody2D = %Door/%DoorBody
@onready var door2_body: StaticBody2D = %Door2/%DoorBody
var opened1 = false
var is_boss = false

func _process(delta: float) -> void:
	if is_boss and not is_instance_valid(boss_instance) and is_instance_valid(door2):
		door2.play("opening")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		opened1 = true
		door1.play("opening")
	

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body is Player:
		$UI/Label.visible = true
		$UI/HealthBar.visible = true
		$Area2D2.queue_free()
		opened1 = false
		door1.visible = true
		door1.play_backwards("opening")
		door1_body.set_collision_mask_value(2,1)
		door1_body.set_collision_layer_value(2,1)
		boss_instance = boss.instantiate()
		add_child(boss_instance)
		boss_instance.position = Vector2(200, -83)
		is_boss = true
		


func _on_door_animation_finished() -> void:
	if opened1 == true:
		door1_body.set_collision_mask_value(2,0)
		door1_body.set_collision_layer_value(2,0)
		door1.visible = false


func _on_door_2_animation_finished() -> void:
	door2.queue_free()
