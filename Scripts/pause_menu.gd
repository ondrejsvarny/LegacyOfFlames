extends Control

@onready var canvas_layer_2: CanvasLayer = $"../../CanvasLayer2"
@onready var canvas_layer: CanvasLayer = $".."

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	canvas_layer_2.layer = 1
	canvas_layer.layer = 2
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	print("jou")

func _process(delta):
	testEsc()

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused and Global.pausable:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused and Global.pausable:
		resume()

func _on_resume_pressed():
	resume()

func _on_character_pressed():
	pass 

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
	
	
