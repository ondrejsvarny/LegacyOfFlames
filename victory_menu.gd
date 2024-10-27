extends Control

var save_path = "user://savegame.save"

var time = 0.0#= Global.speedrun_time
var stop = false
var formatted_time
var record_times = {}
var bonus_times = {
	1: '120.5',
	2: '95.3',
	3: '110.0',
}

@onready var canvas_layer_2: CanvasLayer = $".."
@onready var canvas_layer: CanvasLayer = $"../../CanvasLayer"

@onready var current_time_label: Label = %CurrentTime
@onready var record_label: Label = %"YOUR RECORD"
@onready var new_record_label: Label = %"NEW RECORD!"

@onready var bonus_time_label: Label = %BonusTime
@onready var bonus_cherries: Label = %BonusCherries
@onready var try_again: Label = %TryAgain
@onready var banus_cherry: Sprite2D = %Cherry


func _ready():
	new_record_label.visible = false
	#record_label.text = "YOUR RECORD " + record_times[Global.current_level]
	bonus_time_label.text = bonus_times[Global.current_level]
	
	record_times[1] = '8.00' #SKUSKA
	
func _physics_process(delta):
	if stop == false:
		time += delta
		update_ui()
	# print(time)
	
func update_ui():
	# Format time with two decimal places
	formatted_time = str(time)
	var decimal_index = formatted_time.find(".")
	
	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 3)  # Take only two decimal places
	
	current_time_label.text = formatted_time


func menu_on():
	canvas_layer_2.layer = 2
	canvas_layer.layer = 1
	Global.pausable = false
	stop = true
	get_tree().paused = true
	
	#RECORD TIME CHECK
	if Global.current_level in record_times:
		if float(record_times[Global.current_level]) > float(formatted_time):
			record_times[Global.current_level] = formatted_time
			record_label.text = "YOUR RECORD " + formatted_time
			new_record_label.visible = true
		else:
			record_label.text = "YOUR RECORD " + record_times[Global.current_level]
	else:
		record_times[Global.current_level] = formatted_time
		record_label.text = "YOUR RECORD " + formatted_time
		new_record_label.visible = true
		
	#BONUS TIME CHECK
	#if float(bonus_times[Global.current_level]) > float(formatted_time):
		
	print(record_times[Global.current_level])
	$AnimationPlayer.play("blur")

func menu_off():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Global.pausable = true
	


func _on_restart_pressed() -> void:
	menu_off()
	get_tree().reload_current_scene()
