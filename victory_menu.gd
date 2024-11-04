extends Control

var time = 0.0#= Global.speedrun_time
var stop = false
var formatted_time
var record_times = {}
var bonus_times = {
	1: '10.0',
	2: '95.3',
	3: '110.0',
}
var bonus_cherries = {
	1: 10,
	2: 10,
	3: 10,
}

@onready var canvas_layer_2: CanvasLayer = $".."
@onready var canvas_layer: CanvasLayer = $"../../CanvasLayer"

@onready var current_time_label: Label = %CurrentTime
@onready var record_label: Label = %"YOUR RECORD"
@onready var new_record_label: Label = %"NEW RECORD!"

@onready var bonus_time_label: Label = %BonusTime
@onready var bonus_cherries_label: Label = %BonusCherries
@onready var try_again: Label = %TryAgain
@onready var bonus_cherry_sprite: Sprite2D = %Cherry


func _ready():
	load_data()
	new_record_label.visible = false
	#record_label.text = "YOUR RECORD " + record_times[Global.current_level]
	bonus_time_label.text = bonus_times[Global.current_level]
	
func _physics_process(delta):
	if stop == false:
		time += delta
		update_ui()
	#print(record_times)

	
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
	if float(bonus_times[Global.current_level]) > float(formatted_time):
		Global.cherries += bonus_cherries[Global.current_level]
		bonus_cherries_label.text = "BONUS +" + str(bonus_cherries[Global.current_level])
		bonus_cherry_sprite.visible = true
	else:
		bonus_cherries_label.text = "FOR BONUS TRY AGAIN"
		bonus_cherry_sprite.visible = false 
		
	save()
	
	print(record_times[Global.current_level])
	$AnimationPlayer.play("blur")

func menu_off():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Global.pausable = true

func _on_restart_pressed() -> void:
	menu_off()
	get_tree().reload_current_scene()



func save():
	var data = {
		"record_times": record_times,
	}
	SaveManager.save_section("victory_menu", data)
	
	var currencies = {
		"cherries": Global.cherries
	}
	SaveManager.save_section("global_currencies", currencies)

func load_data():
	var data = SaveManager.load_section("victory_menu")
	record_times = data.get("record_times", {})
	
	var data2 = SaveManager.load_section("global_currencies")
	Global.cherries = data2.get("cherries", 150)
