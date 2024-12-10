extends Control

var time = 0.0#= Global.speedrun_time
var stop = false
var formatted_time
var record_times = {}
var bonus_times = {
	1: '20.0',
	2: '95.0',
	3: '110.0',
}
var bonus_coins = {
	1: 10,
	2: 10,
	3: 10,
}

var bonus_collected = {}

@onready var canvas_layer_2: CanvasLayer = $".."
@onready var canvas_layer: CanvasLayer = $"../../CanvasLayer"

@onready var current_time_label: Label = %CurrentTime
@onready var record_label: Label = %"YOUR RECORD"
@onready var new_record_label: Label = %"NEW RECORD!"

@onready var bonus_time_label: Label = %BonusTime
@onready var bonus_label: Label = %BonusLabel
@onready var bonus_coins_label: Label = %BonusCoinsLabel
#@onready var try_again: Label = %TryAgain
@onready var bonus_coin_sprite: Sprite2D = %Coin

@onready var level_coins: Label = %LevelCoins
@onready var total_coins: Label = %TotalCoins

func _ready():
	load_data()
	Global.level_coins = 0
	new_record_label.visible = false
	#record_label.text = "YOUR RECORD " + record_times[Global.current_level]
	bonus_time_label.text = bonus_times[Global.current_level]
	
func _physics_process(delta):
	if stop == false:
		time += delta
		update_ui()
	#print(Global.level_coins)

	
func update_ui():
	# Format time with two decimal places
	formatted_time = str(time)
	var decimal_index = formatted_time.find(".")
	
	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 3)  # Take only two decimal places
	
	current_time_label.text = formatted_time
	print(formatted_time)


func menu_on():
	canvas_layer_2.layer = 2
	canvas_layer.layer = 1
	Global.pausable = false
	stop = true
	get_tree().paused = true
	
	Global.levels[Global.current_level + 1] = true
	
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
	if float(bonus_times[Global.current_level]) > float(formatted_time) and not bonus_collected.has(Global.current_level):
		Global.coins += bonus_coins[Global.current_level]
		bonus_label.text = "BONUS "
		bonus_coins_label.text = "+" + str(bonus_coins[Global.current_level])
		
		#var new_style = load("res://Assets/UI/Styleboxes/bonus_yes.tres") as StyleBox
		#bonus_coins_label.add_theme_stylebox_override("normal", new_style)
		bonus_coin_sprite.visible = true
		bonus_coins_label.visible = true
		bonus_collected[Global.current_level] = true
	elif bonus_collected[Global.current_level]:
		bonus_label.text = "BONUS COLLECTED"
		bonus_coins_label.visible = false
		bonus_coin_sprite.visible = false
	else:
		bonus_coins_label.text = "FOR BONUS TRY AGAIN"
		#bonus_coins_label.add_theme_stylebox_override("content_margin_right", 20)
		bonus_coins_label.visible = false
		bonus_coin_sprite.visible = false 
		
	# COINS
	level_coins.text= "+" + str(Global.level_coins)
	total_coins.text= str(Global.coins)
	
		
	save()
	
	#print(record_times[Global.current_level])
	$AnimationPlayer.play("blur")

func menu_off():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Global.pausable = true

func _on_restart_pressed() -> void:
	menu_off()
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	menu_off()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func _on_upgrades_pressed() -> void:
	menu_off()
	get_tree().change_scene_to_file("res://Scenes/UI/character_menu.tscn")

func _on_next_pressed() -> void:
	menu_off()
	Global.current_level += 1
	get_tree().change_scene_to_file("res://Scenes/levels/level_" + str(Global.current_level) + ".tscn")
	

func save():
	var data = {
		"record_times": record_times,
		"bonus_collected": bonus_collected
	}
	SaveManager.save_section("victory_menu", data)
	
	var currencies = {
		"coins": Global.coins
	}
	SaveManager.save_section("global_currencies", currencies)
	
	var levels = {
		"levels": Global.levels,
	}
	SaveManager.save_section("levels", levels)

func load_data():
	var data = SaveManager.load_section("victory_menu")
	record_times = data.get("record_times", {})
	bonus_collected = data.get("bonus_collected", {})
	
	var data2 = SaveManager.load_section("global_currencies")
	Global.coins = data2.get("coins", 150)
