extends CanvasLayer

var time = 0.0
var stop = false
var formatted_time
var record_times = {}
var bonus_times = {
	1: 120.0,
	2: 95.0,
	3: 110.0,
	4: 20.0,
	5: 95.0,
	6: 110.0,
	7: 20.0,
	8: 95.0,
	9: 110.0,
	10: 20.0,
}
var bonus_coins = {
	1: 10,
	2: 10,
	3: 10,
	4: 10,
	5: 10,
	6: 10,
	7: 10,
	8: 10,
	9: 10,
	10: 10
}

var bonus_collected = {}

@onready var pause_menu: CanvasLayer = %PauseMenu
@onready var panel: PanelContainer = $PanelContainer

@onready var current_time_label: Label = %CurrentTime
@onready var record_label: Label = %"YOUR RECORD"
@onready var new_record_label: Label = %"NEW RECORD!"

@onready var bonus_time_label: Label = %BonusTime
@onready var bonus_label: Label = %BonusLabel
@onready var bonus_coins_label: Label = %BonusCoinsLabel
@onready var bonus_coin_sprite: Sprite2D = %Coin

@onready var level_coins: Label = %LevelCoins
@onready var total_coins: Label = %TotalCoins
@onready var level_coins_silver: Label = %LevelCoinsSilver
@onready var total_coins_silver: Label = %TotalCoinsSilver


func _ready():
	panel.visible = false
	load_data()
	Global.level_coins = 0
	Global.level_silver_coins = 0
	new_record_label.visible = false
	bonus_time_label.text = format_time(bonus_times[Global.current_level])
	
func _physics_process(delta):
	if not get_tree().paused and Global.can_move and not stop:
		time += delta
		update_ui()

func update_ui():
	formatted_time = format_time(time)
	current_time_label.text = formatted_time
	Global.level_time = formatted_time

func format_time(time_in_seconds: float) -> String:
	var minutes = int(time_in_seconds / 60)
	var seconds = int(time_in_seconds) % 60
	var hundredths = int((time_in_seconds - int(time_in_seconds)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, hundredths]

func menu_on():
	panel.visible = true
	layer = 3
	pause_menu.layer = 1
	Global.pausable = false
	stop = true
	get_tree().paused = true
	
	Global.levels[Global.current_level + 1] = true
	
	if Global.current_level in record_times:
		if record_times[Global.current_level] > time:
			record_times[Global.current_level] = time
			record_label.text = "YOUR RECORD " + format_time(time)
			new_record_label.visible = true
		else:
			record_label.text = "YOUR RECORD " + format_time(record_times[Global.current_level])
	else:
		record_times[Global.current_level] = time
		record_label.text = "YOUR RECORD " + format_time(time)
		new_record_label.visible = true
		
	if bonus_times[Global.current_level] > time and not bonus_collected.has(Global.current_level):
		Global.coins += bonus_coins[Global.current_level]
		bonus_label.text = "BONUS "
		bonus_coins_label.text = "+" + str(bonus_coins[Global.current_level])
		bonus_coin_sprite.visible = true
		bonus_coins_label.visible = true
		bonus_collected[Global.current_level] = true
	elif bonus_collected.has(Global.current_level):
		bonus_label.text = "BONUS COLLECTED"
		bonus_coins_label.visible = false
		bonus_coin_sprite.visible = false
	else:
		bonus_coins_label.text = "FOR BONUS TRY AGAIN"
		bonus_coins_label.visible = false
		bonus_coin_sprite.visible = false 
		
	level_coins.text = "+" + str(Global.level_coins)
	level_coins_silver.text = "+" + str(Global.level_silver_coins)
	total_coins.text = str(Global.coins)
	total_coins_silver.text = str(Global.silver_coins)
	
	save()
	$AnimationPlayer.play("blur")

func menu_off():
	panel.visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Global.pausable = true

func _on_restart_pressed() -> void:
	menu_off()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	menu_off()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func _on_upgrades_pressed() -> void:
	menu_off()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/UI/character_menu.tscn")

func _on_next_pressed() -> void:
	menu_off()
	Global.current_level += 1
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Basic/loading_screen.tscn")
	
func save():
	var data = {
		"record_times": record_times,
		"bonus_collected": bonus_collected
	}
	SaveManager.save_section("victory_menu", data)
	
	var currencies = {
		"coins": Global.coins,
		"silver_coins": Global.silver_coins
	}
	SaveManager.save_section("global_currencies", currencies)
	
	var levels = {
		"levels": Global.levels,
	}
	SaveManager.save_section("levels", levels)

func load_data():
	var data = SaveManager.load_section("victory_menu")
	record_times = data.get("record_times", {})
	# Konverzia starých záznamov (string -> float)
	for level in record_times:
		if typeof(record_times[level]) == TYPE_STRING:
			record_times[level] = float(record_times[level])
	bonus_collected = data.get("bonus_collected", {})
	
	var data2 = SaveManager.load_section("global_currencies")
	Global.coins = data2.get("coins", 0)
	Global.silver_coins = data2.get("silver_coins", 0)
