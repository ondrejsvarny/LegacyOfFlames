extends CanvasLayer

@onready var victory_menu: CanvasLayer = %VictoryMenu
@onready var ui: CanvasLayer = %UI
@onready var panel: PanelContainer = $PanelContainer

func _ready():
	await(is_instance_valid(ui))
	ui.time(false)
	$AnimationPlayer.play("RESET")
	panel.visible = false

func resume():
	ui.time(false)
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	panel.visible = false
	
func pause():
	victory_menu.layer = 1
	layer = 2
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	panel.visible = true

func _process(delta):
	testEsc()

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused and Global.pausable:
		ui.time(true)
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused and Global.pausable:
		ui.time(false)
		resume()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	Global.can_move = true
	resume()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
