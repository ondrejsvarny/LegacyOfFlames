extends Control

var save_path = "user://savegame.save"
#  C:\Users\Ondrej1\AppData\Roaming\Godot\app_userdata\MyGame

var cherries
var SpeedPrice = 15
var SpeedLevel = 1
var HealthPrice = 15
var HealthLevel = 1

@onready var speed_label: Label = %SpeedLabel
@onready var speed_level: Label = %SpeedLevel
@onready var speed_button: Button = %UpgradeSpeed

@onready var health_label: Label = %HealthLabel
@onready var health_level: Label = %HealthLevel
@onready var health_button: Button = %UpgradeHealth


@onready var abilities_content: PanelContainer = $PanelContainer/AllContent/AbilitiesContent
@onready var character_content: PanelContainer = $PanelContainer/AllContent/CharacterContent
@onready var panel_container: PanelContainer = $PanelContainer

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func _on_character_button_pressed() -> void:
	character_content.visible = true
	abilities_content.visible = false
	# Create a new StyleBoxFlat
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.333, 0.333, 0.333)
	# Assign the StyleBoxFlat to the panel_container
	panel_container.add_theme_stylebox_override("panel", stylebox)

func _on_abilities_button_pressed() -> void:
	character_content.visible = false
	abilities_content.visible = true
	# Create a new StyleBoxFlat
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.169, 0.169, 0.169)
	# Assign the StyleBoxFlat to the panel_container
	panel_container.add_theme_stylebox_override("panel", stylebox)


func _ready() -> void:
	load_data()
	health_label.text = "Health: " + str(Global.max_player_health)
	
	speed_level.text = "LEVEL " + str(SpeedLevel)
	speed_button.text = "x" + str(SpeedPrice) + " Upgrade"
	health_level.text = "LEVEL " + str(HealthLevel)
	health_button.text = "x" + str(HealthPrice) + " Upgrade"

func _process(delta: float) -> void:
	if Global.cherries < SpeedPrice or SpeedLevel == 4:
		speed_button.disabled = true
		if SpeedLevel == 4:
			speed_button.text = "    MAX LEVEL    "
	else:
		speed_button.disabled = false
	
	if Global.cherries < HealthPrice or HealthLevel == 4:
		health_button.disabled = true
		if HealthLevel == 4:
			health_button.text = " MAX LEVEL "
	else:
		health_button.disabled = false
	
	

func _on_upgrade_speed_pressed() -> void:
	Global.cherries -= SpeedPrice
	#Global.speed + ...
	SpeedLevel += 1
	speed_level.text = "LEVEL " + str(SpeedLevel)
	SpeedPrice = 2*SpeedPrice
	speed_button.text = "x" + str(SpeedPrice) + " Upgrade"
	save()


func _on_upgrade_health_pressed() -> void:
	Global.cherries -= HealthPrice
	Global.max_player_health += 25
	Global.player_health += 25
	HealthLevel += 1
	health_label.text = "Health: " + str(Global.max_player_health)
	health_level.text = "LEVEL " + str(HealthLevel)
	HealthPrice = 2*HealthPrice
	health_button.text = "x" + str(HealthPrice) + " Upgrade"
	save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var save = {
			"SpeedPrice": SpeedPrice,
			"SpeedLevel": SpeedLevel,
			"HealthPrice": HealthPrice,
			"HealthLevel": HealthLevel,
			"cherries": Global.cherries,
			"max_player_health": Global.max_player_health,
		}
		file.store_var(save)
		file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			HealthPrice = save_data.get("HealthPrice", 15)
			HealthLevel = save_data.get("HealthLevel", 1)
			SpeedPrice = save_data.get("SpeedPrice", 15)  
			SpeedLevel = save_data.get("SpeedLevel", 1)   
			Global.cherries = save_data.get("cherries", 150)
			Global.max_player_health = save_data.get("max_player_health", 100)
			
			print(save_data)
			file.close()

	

	
	
