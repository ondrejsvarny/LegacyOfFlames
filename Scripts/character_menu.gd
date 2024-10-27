extends Control

var save_path = "user://savegame.save"
#  C:\Users\Ondrej1\AppData\Roaming\Godot\app_userdata\MyGame

#var cherries
var SpeedPrice = 10
var SpeedLevel = 1
var HealthPrice = 15
var HealthLevel = 1
var DamagePrice = 10
var DamageLevel = 1
var RelSpeedPrice = 10
var RelSpeedLevel = 1
var ProjSpeedPrice = 10
var ProjSpeedLevel = 1

@onready var speed_level: Label = %SpeedLevel
@onready var speed_button: Button = %UpgradeSpeed

@onready var health_level: Label = %HealthLevel
@onready var health_button: Button = %UpgradeHealth

@onready var fireball_damage_level: Label = %DamageLevel
@onready var fireball_damage_button: Button = %UpgradeDamage

@onready var fireball_rel_speed_level: Label = %RelSpeedLevel
@onready var fireball_rel_speed_button: Button = %UpgradeRelSpeed

@onready var fireball_proj_speed_level: Label = %ProjSpeedLevel
@onready var fireball_proj_speed_button: Button = %UpgradeProjSpeed

@onready var panel_container: PanelContainer = $PanelContainer

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

# READY A PROCESS
func _ready() -> void:
	load_data()
	speed_level.text = "LEVEL " + str(SpeedLevel)
	speed_button.text = "x" + str(SpeedPrice) + " Upgrade"
	health_level.text = "LEVEL " + str(HealthLevel)
	health_button.text = "x" + str(HealthPrice) + " Upgrade"
	fireball_damage_level.text = "LEVEL " + str(DamageLevel)
	fireball_damage_button.text = "x" + str(DamagePrice) + " Upgrade"
	fireball_rel_speed_level.text = "LEVEL " + str(RelSpeedLevel)
	fireball_rel_speed_button.text = "x" + str(RelSpeedPrice) + " Upgrade"
	fireball_proj_speed_level.text = "LEVEL " + str(ProjSpeedLevel)
	fireball_proj_speed_button.text = "x" + str(ProjSpeedPrice) + " Upgrade"

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
		
	if Global.cherries < DamagePrice or DamageLevel == 4:
		fireball_damage_button.disabled = true
		if DamageLevel == 4:
			fireball_damage_button.text = " MAX LEVEL "
	else:
		fireball_damage_button.disabled = false
	
	if Global.cherries < RelSpeedPrice or RelSpeedLevel == 4:
		fireball_rel_speed_button.disabled = true
		if RelSpeedLevel == 4:
			fireball_rel_speed_button.text = " MAX LEVEL "
	else:
		fireball_rel_speed_button.disabled = false
	
	if Global.cherries < ProjSpeedPrice or ProjSpeedLevel == 4:
		fireball_proj_speed_button.disabled = true
		if ProjSpeedLevel == 4:
			fireball_proj_speed_button.text = " MAX LEVEL "
	else:
		fireball_proj_speed_button.disabled = false
	
	
# PLAYER UPGRADES
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
	health_level.text = "LEVEL " + str(HealthLevel)
	HealthPrice = 2*HealthPrice
	health_button.text = "x" + str(HealthPrice) + " Upgrade"
	save()
	

# FIREBALL UPGRADES
func _on_upgrade_damage_pressed() -> void:
	Global.cherries -= DamagePrice
	Global.fireball_damage += 10
	DamageLevel += 1
	fireball_damage_level.text = "LEVEL " + str(DamageLevel)
	DamagePrice = 2*DamagePrice
	fireball_damage_button.text = "x" + str(DamagePrice) + " Upgrade"
	save()
	


func _on_upgrade_rel_speed_pressed() -> void:
	Global.cherries -= RelSpeedPrice
	RelSpeedLevel += 1
	Global.fireball_reload = "fireball_lvl" + str(RelSpeedLevel)
	fireball_rel_speed_level.text = "LEVEL " + str(RelSpeedLevel)
	RelSpeedPrice = 2*RelSpeedPrice
	fireball_rel_speed_button.text = "x" + str(RelSpeedPrice) + " Upgrade"
	save()


func _on_upgrade_proj_speed_pressed() -> void:
	Global.cherries -= ProjSpeedPrice
	Global.fireball_speed += 0.5
	ProjSpeedLevel += 1
	fireball_proj_speed_level.text = "LEVEL " + str(ProjSpeedLevel)
	ProjSpeedPrice = 2*ProjSpeedPrice
	fireball_proj_speed_button.text = "x" + str(ProjSpeedPrice) + " Upgrade"
	save()


# SECOND ATTACK UPGRADES


# SAVE AND LOAD
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var save = {
			"SpeedPrice": SpeedPrice,
			"SpeedLevel": SpeedLevel,
			"HealthPrice": HealthPrice,
			"HealthLevel": HealthLevel,
			"DamagePrice": DamagePrice,
			"DamageLevel": DamageLevel,
			"RelSpeedPrice": RelSpeedPrice,
			"RelSpeedLevel": RelSpeedLevel,
			"ProjSpeedPrice": ProjSpeedPrice,
			"ProjSpeedLevel": ProjSpeedLevel,
			
			"max_player_health": Global.max_player_health,
			"fireball_damage": Global.fireball_damage,
			"fireball_reload": Global.fireball_reload,
			"fireball_speed": Global.fireball_speed,
			
			"cherries": Global.cherries
		}
		file.store_var(save)
		file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			
			SpeedPrice = save_data.get("SpeedPrice", 10)  
			SpeedLevel = save_data.get("SpeedLevel", 1) 
			HealthPrice = save_data.get("HealthPrice", 15)
			HealthLevel = save_data.get("HealthLevel", 1)  
			DamagePrice = save_data.get("DamagePrice", 10)
			DamageLevel = save_data.get("DamageLevel", 1)
			RelSpeedPrice = save_data.get("RelSpeedPrice", 10)
			RelSpeedLevel = save_data.get("RelSpeedLevel", 1)
			ProjSpeedPrice = save_data.get("ProjSpeedPrice", 10)
			ProjSpeedLevel = save_data.get("ProjSpeedLevel", 1)
			
			Global.max_player_health = save_data.get("max_player_health", 100)
			Global.fireball_damage = save_data.get("fireball_damage", 10)
			Global.fireball_reload = save_data.get("fireball_reload", "fireball_lvl1")
			Global.fireball_speed = save_data.get("fireball_speed", 3)
			
			Global.cherries = save_data.get("cherries", 150)
			
			print(save_data)
			file.close()
			
